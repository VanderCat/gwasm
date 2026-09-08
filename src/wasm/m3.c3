module wasm3;
import std::core::cinterop;
alias M3Result = char*;

typedef M3Environment = void;
typedef M3Runtime = void;
typedef M3Module = void;
typedef M3Function = void;
typedef M3Global = void;

struct M3ErrorInfo {
    M3Result    result;

    M3Runtime*  runtime;
    M3Module*   module_;
    M3Function* function;

    char* file;
    uint    line;

    char* message;
}

struct M3BacktraceFrame {
    uint                 moduleOffset;
    M3Function*              function;

    M3BacktraceFrame* next;
}
alias IM3BacktraceFrame = M3BacktraceFrame*;

struct M3BacktraceInfo {
    IM3BacktraceFrame frames;
    IM3BacktraceFrame lastFrame;    // can be M3_BACKTRACE_TRUNCATED
}
alias IM3BacktraceInfo = M3BacktraceInfo*;



constdef M3ValueType {
    NONE      = 0,
    I32       = 1,
    I64       = 2,
    F32       = 3,
    F64       = 4,

    // Opaque 16-byte slot used purely so wasm3 can PARSE modules
    // whose function signatures or local-variable declarations
    // mention v128 (the SIMD value type, wasm-encoded as 0x7B).
    // Actual v128 OPCODES still error at compile-time with
    // m3Err_unknownOpcode - we only avoid the parse-time
    // m3Err_invalidTypeId rejection. LLVM's auto-vectorizer emits
    // unused v128 locals into many `+simd128` modules even when no
    // SIMD op executes; without this slot wasm3 rejects every such
    // module before it ever sees a function body.
    V128      = 5,

    // Reference values are opaque pointer-sized words and null is always 0.
    // A funcref holds an M3Function*; an externref holds a host-defined handle,
    // which the host is free to encode however it likes as long as 0 means null.
    FUNCREF   = 6,
    EXTERNREF = 7,

    // A caught exception, from the exception handling proposal. Holds a pointer
    // to a runtime-owned exception object, or 0 for the null reference. The
    // object belongs to the runtime and stays alive until the outermost
    // m3_Call() that produced it returns - a host that stashes one past that
    // point is holding a dangling reference.
    EXNREF    = 8,

    // the number of concrete value types
    COUNT,

    // "not a valid type" - returned where a lookup or a mapping failed.
    UNKNOWN = COUNT
}

struct M3TaggedValue {
    M3ValueType type;
    union value {
        uint    i32;
        ulong    i64;
        float       f32;
        double      f64;
        void* ref;        // funcref / externref; NULL is the null reference
    }
}

struct M3ImportInfo {
    char* moduleUtf8;
    char* fieldUtf8;
}

struct M3ImportContext {
    void*       userdata;
    M3Function* function;
}

alias M3RawCall = fn void*(M3Runtime* runtime, M3ImportContext* _ctx, ulong* _sp, void* _mem);

alias M3SectionHandler = fn M3Result(M3Module* i_module, char* name, char* start, char* end);

//-------------------------------------------------------------------------------------------------------------------------------
//  global environment than can host multiple runtimes
//-------------------------------------------------------------------------------------------------------------------------------
extern fn M3Environment* new_environment() @cname("m3_NewEnvironment");

extern fn void M3Environment.free(M3Environment* i_environment) @cname("m3_FreeEnvironment");

extern fn void M3Environment.set_custom_section_handler(M3Environment* i_environment, M3SectionHandler i_handler) @cname("m3_SetCustomSectionHandler");


//-------------------------------------------------------------------------------------------------------------------------------
//  execution context
//-------------------------------------------------------------------------------------------------------------------------------

extern fn M3Runtime* M3Environment.new_runtime(M3Environment* io_environment,
                                uint       i_stackSizeInBytes,
                                void*          i_userdata) @cname("m3_NewRuntime");

extern fn void M3Runtime.free_runtime(M3Runtime* i_runtime) @cname("m3_FreeRuntime");

// The validator runs as a pre-pass of compiling a function body, so it
// follows lazy compilation: a body is checked the first time it is compiled.
// Turning it off means trusting the module - nothing then checks a body's
// types before it runs. On by default(a no-op in a build without validation).
extern fn void M3Runtime.set_validation(M3Runtime* i_runtime, bool i_enable) @cname("m3_SetValidation");

// Gas metering. Arming a runtime with a gas budget makes the compiler
// instrument the function bodies it compiles from then on: each straight-line
// segment of a body is charged, before any of it runs, for the instructions it
// is about to execute. Running the budget out traps with m3Err_trapOutOfGas,
// which no amount of Wasm can catch, so this bounds how long a module can run
// as well as how much it can do.
//
// Costs come from ewasm's metering design, whose unit is a ten-thousandth of a
// gas - hence the fractional gas these speak in. Instrumentation follows lazy
// compilation, so a body already compiled when the limit is set is not metered:
// arm the runtime before running anything. Setting a new limit re-arms the
// runtime with a full budget, and does not recompile what is already compiled.
//
// The gas used can exceed the limit by the cost of the segment that ran out -
// it is charged in full before the trap. A build with d_m3HasGasMetering=0
// compiles the instrumentation out: m3_SetGasLimit does nothing there, and the
// two getters answer 0.
extern fn void M3Runtime.set_gas_limit(M3Runtime* i_runtime, double i_gas) @cname("m3_SetGasLimit");

extern fn double M3Runtime.get_gas_limit(M3Runtime* i_runtime) @cname("m3_GetGasLimit");
extern fn double M3Runtime.get_gas_used(M3Runtime* i_runtime) @cname("m3_GetGasUsed");

// A memory belongs to the module that declares it, so these take the module
// rather than the runtime - a runtime can hold several modules, each with
// its own memories. Returns NULL when the module has no memory at that
// index; o_memorySizeInBytes is set either way.
//
// Sizes are sz, not uint: a linear memory may be a full 4 GiB, which
// is one byte too many to count in 32 bits.
extern fn char* get_memory(M3Module* i_module,
                               sz*   o_memorySizeInBytes,
                               uint  i_memoryIndex) @cname("m3_GetMemory");

extern fn sz get_memory_size(M3Module* i_module,
                                   uint  i_memoryIndex) @cname("m3_GetMemorySize");

// Size of the memory a pointer addresses into - specifically the _mem a raw
// function is handed, which is the memory of whichever module is calling,
// and need not be any particular module's. Used by m3ApiCheckMem.
extern fn sz get_memory_size_at(void* i_memory) @cname("m3_GetMemorySizeAt");

extern fn void* get_user_data(M3Runtime* i_runtime) @cname("m3_GetUserData");

// The index of the memory the module exports under i_name. A host module
// whose ABI names the memory it addresses looks it up this way - WASI names
// it "memory". Returns m3Err_unknownMemory when no memory is exported
// under that name.
extern fn M3Result find_exported_memory(M3Module*         i_module,
                                        char* i_name,
                                        uint*         o_memoryIndex) @cname("m3_FindExportedMemory");

// Pin which of the module's memories the host functions imported from
// i_importModule address("*" for every namespace, as in
// m3_LinkRawFunction). Applies to imports already bound to a host function,
// so call it after linking them. Left alone, a host function addresses
// memory 0 - what a bare i32 guest pointer means when nothing says
// otherwise - so this is only needed by a host module that names a memory.
extern fn M3Result bind_import_memory(M3Module*         io_module,
                                      char* i_importModule,
                                      uint          i_memoryIndex) @cname("m3_BindImportMemory");


//-------------------------------------------------------------------------------------------------------------------------------
//  modules
//-------------------------------------------------------------------------------------------------------------------------------

// i_wasmBytes data must be persistent during the lifetime of the module
extern fn M3Result parse_module(M3Environment*       i_environment,
                                 M3Module**           o_module,
                                 char* i_wasmBytes,
                                 uint             i_numWasmBytes) @cname("m3_ParseModule");

// Only a module that was never handed to m3_LoadModule needs to be freed.
extern fn void free_module(M3Module* i_module) @cname("m3_FreeModule");

//  Transfers ownership of the module to the runtime - whether or not it
//  succeeds. A failed instantiation can already have written this module's
//  functions into a table another module owns, and the spec keeps whatever
//  it managed to do, so those entries stay callable; the module has to
//  outlive the failure for them not to dangle. m3_FreeRuntime releases it.
//  Do not call m3_FreeModule on a module after passing it here.
extern fn M3Result M3Runtime.load_module(M3Runtime* io_runtime, M3Module* io_module) @cname("m3_LoadModule");

// Optional, compiles all functions in the module
extern fn M3Result compile_module(M3Module* io_module) @cname("m3_CompileModule");

// Calling m3_RunStart is optional
extern fn M3Result run_start(M3Module* i_module) @cname("m3_RunStart");

// Arguments and return values are passed in and out through the stack pointer _sp.
// Placeholder return value slots are first and arguments after. So, the first argument is at _sp [numReturns]
// Return values should be written into _sp [0] to _sp [num_returns - 1]
extern fn M3Result link_raw_function(M3Module*         io_module,
                                     char* i_moduleName,
                                     char* i_functionName,
                                     char* i_signature,
                                     M3RawCall         i_function) @cname("m3_LinkRawFunction");

extern fn M3Result link_raw_function_ex(M3Module*         io_module,
                                       char* i_moduleName,
                                       char* i_functionName,
                                       char* i_signature,
                                       M3RawCall         i_function,
                                       void*       i_userdata) @cname("m3_LinkRawFunctionEx");

// supplies the value of an imported global, regardless of its mutability
extern fn M3Result link_global(M3Module*            io_module,
                                char*    i_moduleName,
                                char*    i_globalName,
                                M3TaggedValue* i_value) @cname("m3_LinkGlobal");

extern fn char*      get_module_name(M3Module* i_module) @cname("m3_GetModuleName");
extern fn void set_module_name(M3Module* i_module, char* name) @cname("m3_SetModuleName");
extern fn M3Runtime* get_module_runtime(M3Module* i_module) @cname("m3_GetModuleRuntime");

// The module registered under i_moduleName, or NULL. Most recently loaded
// first, so a name registered twice names the newer module.
extern fn M3Module* M3Runtime.find_module(M3Runtime*        i_runtime,
                                char* i_moduleName) @cname("m3_FindModule");

//-------------------------------------------------------------------------------------------------------------------------------
//  globals
//-------------------------------------------------------------------------------------------------------------------------------
extern fn M3Global* find_global(M3Module*         io_module,
                                char* i_globalName) @cname("m3_FindGlobal");

extern fn M3Result get_global(M3Global*      i_global,
                               M3TaggedValue* o_value) @cname("m3_GetGlobal");

extern fn M3Result set_global(M3Global*            i_global,
                               M3TaggedValue* i_value) @cname("m3_SetGlobal");

extern fn M3ValueType get_global_type(M3Global* i_global) @cname("m3_GetGlobalType");

//-------------------------------------------------------------------------------------------------------------------------------
//  functions
//-------------------------------------------------------------------------------------------------------------------------------
extern fn M3Result yield() @cname("m3_Yield");

// o_function is valid during the lifetime of the originating runtime.
// m3_FindFunction searches every module loaded into the runtime, most
// recently loaded first; m3_FindFunctionIn searches just the one, which is
// what naming a module's export means.
extern fn M3Result find_function(M3Function**      o_function,
                                  M3Runtime*        i_runtime,
                                  char* i_functionName) @cname("m3_FindFunction");
extern fn M3Result find_function_in(M3Function**      o_function,
                                    M3Module*         i_module,
                                    char* i_functionName) @cname("m3_FindFunctionIn");
extern fn M3Result get_table_function(M3Function** o_function,
                                      M3Module*    i_module,
                                      uint     i_index) @cname("m3_GetTableFunction");

extern fn uint get_arg_count(M3Function* i_function) @cname("m3_GetArgCount");
extern fn uint get_ret_count(M3Function* i_function) @cname("m3_GetRetCount");
extern fn M3ValueType get_arg_type(M3Function* i_function, uint i_index) @cname("m3_GetArgType");
extern fn M3ValueType get_ret_type(M3Function* i_function, uint i_index) @cname("m3_GetRetType");

extern fn M3Result call_v(M3Function* i_function, ...) @cname("m3_CallV");
extern fn M3Result call_vl(M3Function* i_function, CVaList i_args) @cname("m3_CallVL");
extern fn M3Result call(M3Function* i_function, uint i_argc, void*[] i_argptrs) @cname("m3_Call");
extern fn M3Result call_argv(M3Function* i_function, uint i_argc, char*[] i_argv) @cname("m3_CallArgv");

extern fn M3Result get_results_v(M3Function* i_function, ...) @cname("m3_GetResultsV");
extern fn M3Result get_results_vl(M3Function* i_function, CVaList o_rets) @cname("m3_GetResultsVL");
extern fn M3Result get_results(M3Function* i_function, uint i_retc, void*[] o_retptrs) @cname("m3_GetResults");


extern fn void M3Runtime.get_error_info(M3Runtime* i_runtime, M3ErrorInfo* o_info) @cname("m3_GetErrorInfo");
extern fn void M3Runtime.reset_error_info(M3Runtime* i_runtime) @cname("m3_ResetErrorInfo");

extern fn char*      get_function_name(M3Function* i_function) @cname("m3_GetFunctionName");
extern fn M3Module* get_function_module(M3Function* i_function) @cname("m3_GetFunctionModule");

//-------------------------------------------------------------------------------------------------------------------------------
//  debug info
//-------------------------------------------------------------------------------------------------------------------------------

extern fn void M3Runtime.print_runtime_info(M3Runtime* i_runtime) @cname("m3_PrintRuntimeInfo");
extern fn void print_m3_info() @cname("m3_PrintM3Info");
extern fn void print_profiler_info() @cname("m3_PrintProfilerInfo");

// The runtime owns the backtrace, do not free the backtrace you obtain. Returns NULL if there's no backtrace.
extern fn IM3BacktraceInfo M3Runtime.get_backtrace(M3Runtime* i_runtime) @cname("m3_GetBacktrace");