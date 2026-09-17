module gmod_wasm::lua;

import gmod;
import libc;
import wasm3;
import std::core::string;

struct M3RuntimeUserdata {
	M3Runtime* runtime;
	gmod::LuaState* state;
	sz referenceCount;
}
struct M3FunctionUserdata {
	M3RuntimeUserdata* runtimeUserdata;
	int functionReference;
}

fn bool M3RuntimeUserdata.owns(M3RuntimeUserdata*, M3Module* mod) {
	return true; //TODO: STUB
}

macro luaL_getmetatable(gmod::LuaState* l, char* n) {
	return l.luabase.get_field(gmod::Index.REGISTRY, (n));
}

macro @push_runtime(gmod::LuaState* l, M3Runtime* runtime) {
	if (runtime == null) {
		gmod_wasm::@log(l, "null pointer pushed here");
		l.luabase.throw_error("attempt to push null pointer");
	}
	gmod_wasm::@log(l, "pushing runtime %x", runtime);
	M3RuntimeUserdata* udata = (M3RuntimeUserdata*)runtime.get_user_data();
	gmod_wasm::@log(l, "udata pointer is %x", udata);
	if (udata == null) {
		gmod_wasm::@log(l, "something went seriously wrong, the userdata pointer is null, expect a crash soon!");
	} else {
		udata.referenceCount += 1;
	}
	//((M3RuntimeUserdata*)runtime.get_user_data()).referenceCount += 1;
	l.luabase.push_user_type(runtime, runtime_type);
	l.luabase.push_meta_table(runtime_type);
    l.luabase.set_meta_table(-2);
}
macro @push_module(gmod::LuaState* l, M3Module* module_) {
	if (module_ == null) {
		gmod_wasm::@log(l, "null pointer pushed here");
		l.luabase.throw_error("attempt to push null pointer");
	}
	l.luabase.push_user_type(module_, module_type);
	l.luabase.push_meta_table(module_type);
    l.luabase.set_meta_table(-2);
}
macro @push_function(gmod::LuaState* l, M3Function* func) {
	if (func == null) {
		gmod_wasm::@log(l, "null pointer pushed here");
		l.luabase.throw_error("attempt to push null pointer");
	}
	l.luabase.push_user_type(func, function_type);
	l.luabase.push_meta_table(function_type);
    l.luabase.set_meta_table(-2);
}
macro @push_global(gmod::LuaState* l, M3Global* global) {
	if (global == null) {
		gmod_wasm::@log(l, "null pointer pushed here");
		l.luabase.throw_error("attempt to push null pointer");
	}
	l.luabase.push_user_type(global, global_type);
	l.luabase.push_meta_table(global_type);
    l.luabase.set_meta_table(-2);
}
macro @push_error(gmod::LuaState* l, M3Result error) {
	l.luabase.push_nil();
	l.luabase.push_string(error, 0);
}

fn int new_runtime(gmod::LuaState* l) {
    l.luabase.check_number(1);
	uint i_stackSizeInBytes = (uint)l.luabase.get_number(1);
	gmod_wasm::@log(l, "called with %u", i_stackSizeInBytes);
	defer gmod_wasm::@log(l, "exiting");
    // void** ptr = (void**)l.luabase.new_userdata(uptr::size);
	M3RuntimeUserdata* userdata = mem::new(M3RuntimeUserdata);
	userdata.state = l;
	userdata.referenceCount = 1;
	gmod_wasm::@log(l, "created udata");
	gmod_wasm::@log(l, "udata pointer is %x", userdata);
	M3Runtime* runtime = gmod_wasm::wasm_env.new_runtime(i_stackSizeInBytes, userdata);
	userdata.runtime = runtime;
	gmod_wasm::@log(l, "sanity check: %x", runtime.get_user_data());
	gmod_wasm::@log(l, "created runtime\n");
	@push_runtime(l, runtime);
	l.luabase.msg("uhhh...\n");
	return 1;
}
fn int yield(gmod::LuaState* l) {
	wasm3::yield();
	return 0;
}

fn int parse_module(gmod::LuaState* l) {
	M3Module* module_;
	CInt len;
	char* buf = l.luabase.get_string(1, &len); //TODO: this pointer should not be garbage collected until module is freed, is it possible?
	String view = (String)buf[:len];
	LibcAllocator libc;
	String copy = view.copy(&libc);   // leaky!
	M3Result result = gmod_wasm::wasm_env.parse_module(&module_, copy, (uint)copy.len);
	if (result == null) {
		@push_module(l, module_);
		return 1;
	}
	@push_error(l, result);
	return 2;
}
macro @assert(gmod::LuaState* l, bool arg, char* error) {
	if (!arg) l.luabase.throw_error(error);
}
macro @is_runtime(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, runtime_type);
}
macro @is_module(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, module_type);
}
macro @is_function(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, function_type);
}
macro @is_global(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, global_type);
}
macro @is_bool(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, (int)gmod::Types.BOOL);
}
macro @is_string(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, (int)gmod::Types.STRING);
}
macro M3Runtime* @get_runtime(gmod::LuaState* l, int stackPos) {
	M3Runtime* runtime = (M3Runtime*)l.luabase.get_user_type(stackPos, runtime_type);
	@assert(l, runtime != null, "lua received null module");
	return runtime;
}
macro M3Module* @get_module(gmod::LuaState* l, int stackPos) {
	M3Module* mod = (M3Module*)l.luabase.get_user_type(stackPos, module_type);
	@assert(l, mod != null, "lua received null module");
	return mod;
}
macro M3Function* @get_function(gmod::LuaState* l, int stackPos) {
	M3Function* func = (M3Function*)l.luabase.get_user_type(stackPos, function_type);
	@assert(l, func != null, "lua received null function");
	return func;
}
macro @get_global(gmod::LuaState* l, int stackPos) {
	return (M3Global*)l.luabase.get_user_type(stackPos, global_type);
}
fn int free_runtime(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	gmod_wasm::@log(l, "freeing the runtime");
	((M3RuntimeUserdata*)runtime.get_user_data()).referenceCount -= 1;
	if (((M3RuntimeUserdata*)runtime.get_user_data()).referenceCount == 0) {
		runtime.free_runtime();
	}
	return 0;
}

fn int set_validation(gmod::LuaState* l) {
	@is_runtime(l, 1);
	@is_bool(l, 2);
	M3Runtime* runtime = @get_runtime(l, 1);
	bool enable = l.luabase.get_bool(2);
	runtime.set_validation(enable);
	return 0;
}
fn int set_gas_limit(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	double gas = l.luabase.check_number(2);
	runtime.set_gas_limit(gas);
	return 0;
}
fn int get_gas_limit(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	l.luabase.push_number(runtime.get_gas_limit());
	return 1;
}
fn int get_gas_used(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	l.luabase.push_number(runtime.get_gas_used());
	return 1;
}
fn int load_module(gmod::LuaState* l) {
	@is_runtime(l, 1);
	@is_module(l, 2);
	M3Runtime* runtime = @get_runtime(l, 1);
	M3Module* mod = @get_module(l, 2);
	M3Result res = runtime.load_module(mod);
	if (res != null) {
		l.luabase.throw_error(res);
	}
	return 0;
}
fn int find_function(gmod::LuaState* l) {
	@is_runtime(l, 1);
	@is_string(l, 2);
	M3Runtime* runtime = @get_runtime(l, 1);
	M3Function* function;
	char* str = l.luabase.get_string(2, null);
	M3Result res = wasm3::find_function(&function, runtime, str);
	if (res == null) {
		@push_function(l, function);
		return 1;
	}
	@push_error(l, res);
	return 2;
}
fn int find_module(gmod::LuaState* l) {
	@is_runtime(l, 1);
	@is_string(l, 2);
	M3Runtime* runtime = @get_runtime(l, 1);
	char* str = l.luabase.get_string(2, null);
	M3Module* mod = runtime.find_module(str);
	if (mod != null) {
		@push_module(l, mod);
	} else {
		l.luabase.push_nil();
	}
	return 1;
}
fn int get_error_info(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	M3ErrorInfo info;
	runtime.get_error_info(&info);
	if (info.result == null && 
		info.file == null && 
		info.message == null && 
		info.line == 0 && 
		info.module_ == null && 
		info.runtime == null &&
		info.function == null
		) {
			return 0; // no error
		}
	l.luabase.create_table();
	if (info.result != null) {
		l.luabase.push_string(info.result);
		l.luabase.set_field(-2, "result");
	}
	if (info.file != null) {
		l.luabase.push_string(info.file);
		l.luabase.set_field(-2, "file");
	}
	if (info.message != null) {
		l.luabase.push_string(info.message);
		l.luabase.set_field(-2, "message");
	}
	if (info.line != 0) {
		l.luabase.push_number(info.line);
		l.luabase.set_field(-2, "line");
	}
	if (info.module_ != null) {
		@push_module(l, info.module_);
		l.luabase.set_field(-2, "module");
	}
	if (info.runtime != null) {
		@push_runtime(l, info.runtime);
		l.luabase.set_field(-2, "runtime");
	}
	if (info.function != null) {
		@push_function(l, info.function);
		l.luabase.set_field(-2, "function");
	}
	return 1;
}
fn int reset_error_info(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	runtime.reset_error_info();
	return 0;
}
fn int get_backtrace(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	M3BacktraceInfo* backtrace = runtime.get_backtrace();
	//backtrace
	//TODO:
	return 0;
}

macro @add_function(gmod::LuaState* l, char* name, func) {
	l.luabase.push_c_function(func); 
	l.luabase.set_field(-2, name);
}
fn void create_metatables(gmod::LuaState* l) {
	create_runtime_metatable(l);
	create_module_metatable(l);
	create_function_metatable(l);
	create_global_metatable(l);
	create_memory_view_metatable(l);
}
int runtime_type = 0;
fn void create_runtime_metatable(gmod::LuaState* l) {
	l.luabase.msg("[WASM] Creating metatable for M3Runtime*\n");
	runtime_type = l.luabase.create_meta_table("M3Runtime*");
	@add_function(l, "__gc", &free_runtime);
	// @add_function(l, "Free", &free_runtime); // if you try freeing already freed object the game will crash, so let's hope gc free it when necessary
	@add_function(l, "SetValidation", &set_validation);
	@add_function(l, "SetGasLimit", &set_gas_limit);
	@add_function(l, "GetGasLimit", &get_gas_limit);
	@add_function(l, "GetGasUsed", &get_gas_used);
	@add_function(l, "LoadModule", &load_module);
	@add_function(l, "FindModule", &find_module);
	@add_function(l, "FindFunction", &find_function);
	@add_function(l, "GetErrorInfo", &get_error_info);
	@add_function(l, "ResetErrorInfo", &reset_error_info);
	@add_function(l, "GetBacktrace", &get_backtrace);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Runtime* successfully created\n");
}
fn int module_free(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	M3RuntimeUserdata* ud = (M3RuntimeUserdata*)mod.get_runtime().get_user_data();
	if (!ud.owns(mod)) {
		mod.free(); // this could be garbage collected safely 
	}
	return 0;
}
fn int get_memory(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.create_table();
	l.luabase.push(1);
	l.luabase.set_field(-2, "__module");
	l.luabase.push_meta_table(memview_type);
	l.luabase.set_meta_table(-2);
	return 1;
}
fn int get_memory_size(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	sz size;
	mod.get_memory_size((uint)l.luabase.check_number(2));
	l.luabase.push_number((double)size);
	return 1;
}

fn int find_exported_memory(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	l.luabase.throw_error("not implemented");
}
fn int bind_import_memory(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	l.luabase.throw_error("not implemented");
}
fn int run_start(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	M3Result result = mod.run_start();
	if (result != null) {
		l.luabase.throw_error(result);
	}
	return 0;
}
fn int compile(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	M3Result result = mod.compile();
	if (result != null) {
		l.luabase.throw_error(result);
	}
	return 0;
}
// Arguments and return values are passed in and out through the stack pointer _sp.
// Placeholder return value slots are first and arguments after. So, the first argument is at _sp [numReturns]
// Return values should be written into _sp [0] to _sp [num_returns - 1]
// Example stack int calc(1, 2) -> [return, 1, 2] 
fn void* rawfunc(M3Runtime* runtime, M3ImportContext* _ctx, ulong* _sp, void* _mem) {
	M3FunctionUserdata* udata = _ctx.userdata; //does it change the userdata outside of function calling scope?
	gmod::LuaState* l = udata.runtimeUserdata.state;
	gmod_wasm::@log(l, "hello :3");
	uint iArgs = _ctx.function.get_arg_count();
	uint iRets = _ctx.function.get_ret_count();
	for (uint i = 0; i < iArgs; i += 1) {
		void* arg = (void*)_sp[iRets+i];
		M3ValueType type = _ctx.function.get_arg_type(i);
		switch (type) {
			case I32:
				l.luabase.push_number(*(int*)arg);
			case I64:
				l.luabase.push_number(*(long*)arg);
			case F32:
				l.luabase.push_number(*(float*)arg);
			case F64:
				l.luabase.push_number(*(double*)arg);
			case FUNCREF:
				M3Function* ptr = (M3Function*)arg;
				if (arg == null) {
					l.luabase.push_nil();
				} else {
					@push_function(l, (M3Function*)arg);
				}
			default:
				l.luabase.msg("unknown arg! got TODO");
				//l.luabase.msg(type::);
				l.luabase.msg("\n");
				break;
		}
	}
	l.luabase.reference_push(udata.functionReference);
	l.luabase.call((int)iArgs, (int)iRets); //TODO: pcall
	for (uint i = 0; i < iRets; i += 1) {
		void* arg = (void*)_sp[i];
		M3ValueType type = _ctx.function.get_ret_type(i);
		int luaStackPos = ((int)i)-((int)iRets);
		switch (type) {
			case I32:
				(*(int*)arg) = (int)l.luabase.get_number(luaStackPos);
			case I64:
				(*(long*)arg) = (long)l.luabase.get_number(luaStackPos);
			case F32:
				(*(float*)arg) = (float)l.luabase.get_number(luaStackPos);
			case F64:
				(*(double*)arg) = l.luabase.get_number(luaStackPos);
			// case FUNCREF:
			// 	@push_function(l, (M3Function*)arg);
			// 	break;
			default:
				l.luabase.msg("not supported ret! got TODO");
				//l.luabase.msg(type::description);
				l.luabase.msg("\n");
				break;
		}
	}
	return null;
}
fn int link_raw_function(gmod::LuaState* l) {
	@is_module(l, 1);
	@is_string(l, 2);
	@is_string(l, 3);
	@is_string(l, 4);
	l.luabase.check_type(5, (int)gmod::Types.FUNCTION);
	M3Module* mod = @get_module(l, 1);
	char* moduleName = l.luabase.get_string(2, null);
	char* functionName = l.luabase.get_string(3, null);
	char* signature = l.luabase.get_string(4, null);
	int funcRef = l.luabase.reference_create();
	gmod_wasm::@log(l, "linking fn %i as %s.%s of sig %s", funcRef, moduleName, functionName, signature);
	M3FunctionUserdata* fnUdata = mem::new(M3FunctionUserdata); //TODO: cleanup on runtime close? 
	fnUdata.runtimeUserdata = mod.get_runtime().get_user_data();
	fnUdata.functionReference = funcRef;
	M3Result result = mod.link_raw_function_ex(moduleName, functionName, signature, &rawfunc, (void*)fnUdata);
	if (result != null) {
		l.luabase.throw_error(result);
	}
	return 0;
}
fn int link_global(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.throw_error("not implemented");
}
fn int get_name(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	l.luabase.push_string(mod.get_name(), 0);
	return 0;
}
fn int set_name(gmod::LuaState* l) {
	@is_module(l, 1);
	@is_string(l, 2);
	M3Module* mod = @get_module(l, 1);
	char* name = l.luabase.get_string(2, null);
	mod.set_name(name);
	return 1;
}
fn int get_runtime(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	M3Runtime* runtime = mod.get_runtime();
	@push_runtime(l, runtime);
	return 1;
}
fn int find_function_in(gmod::LuaState* l) {
	@is_module(l, 1);
	@is_string(l, 2);
	M3Module* mod = @get_module(l, 1);
	M3Function* func;
	M3Result res = wasm3::find_function_in(&func, mod, l.luabase.get_string(2));
	if (res != null) {
		@push_error(l, res);
		return 2;
	}
	@push_function(l, func);
	return 1;
}
fn int find_global(gmod::LuaState* l) {
	@is_module(l, 1);
	@is_string(l, 2);
	M3Module* mod = @get_module(l, 1);
	M3Global* glob = mod.find_global(l.luabase.get_string(2));
	@push_global(l, glob);
	return 1;
}
fn int get_table_function(gmod::LuaState* l) {
	@is_module(l, 1);
	M3Module* mod = @get_module(l, 1);
	double num = l.luabase.check_number(2);
	M3Function* func;
	M3Result res = wasm3::get_table_function(&func, mod, (uint)num);
	if (res == null) {
		@push_function(l, func);
		return 1;
	}
	@push_error(l, res);
	return 2;
}
int module_type = 0;
fn void create_module_metatable(gmod::LuaState* l) {
	l.luabase.msg("[WASM] Creating metatable for M3Module\n");
	module_type = l.luabase.create_meta_table("M3Module*");
	@add_function(l, "__gc", &module_free); // FIXME: Only a module that was never handed to LoadModule needs to be freed.
	@add_function(l, "GetMemory", &get_memory);
	@add_function(l, "GetMemorySize", &get_memory_size);
	@add_function(l, "FindExportedMemory", &find_exported_memory);
	@add_function(l, "BindImportMemory", &bind_import_memory);
	@add_function(l, "RunStart", &run_start);
	@add_function(l, "Compile", &compile);
	@add_function(l, "LinkFunction", &link_raw_function);
	@add_function(l, "LinkGlobal", &link_global);
	@add_function(l, "GetName", &get_name);
	@add_function(l, "SetName", &set_name);
	@add_function(l, "GetRuntime", &get_runtime);
	@add_function(l, "FindFunction", &find_function_in);
	@add_function(l, "FindGlobal", &find_global);
	@add_function(l, "GetTableFunction", &get_table_function);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Module successfully created\n");
}
fn int get_arg_count(gmod::LuaState* l) {
	@is_function(l, 1);
	M3Function* func = @get_function(l, 1);
	l.luabase.push_number(func.get_arg_count());
	return 1;
}
fn int get_ret_count(gmod::LuaState* l) {
	@is_function(l, 1);
	M3Function* func = @get_function(l, 1);
	l.luabase.push_number(func.get_ret_count());
	return 1;
}
fn int get_arg_type(gmod::LuaState* l) {
	@is_function(l, 1);
	M3Function* func = @get_function(l, 1);
	uint number = (uint)l.luabase.check_number(2);
	M3ValueType res = func.get_arg_type(number);
	l.luabase.push_string(@get_enum_name(res), 0);
	return 1;
}
macro ZString @get_enum_name(M3ValueType t) {
	switch (t) {
		case M3ValueType.NONE:
			return "none";
			break;
		case M3ValueType.I64:
			return "i64";
			break;
		case M3ValueType.I32:
			return "i32";
			break;
		case M3ValueType.F32:
			return "f32";
			break;
		case M3ValueType.F64:
			return "f64";
			break;
		case M3ValueType.V128:
			return "v128";
			break;
		case M3ValueType.FUNCREF:
			return "funcref";
			break;
		case M3ValueType.EXNREF:
			return "exnref";
			break;
		case M3ValueType.EXTERNREF:
			return "externref";
			break;
	}
	return null;
}
fn int get_ret_type(gmod::LuaState* l) {
	@is_function(l, 1);
	M3Function* func = @get_function(l, 1);
	uint number = (uint)l.luabase.check_number(2);
	M3ValueType res = func.get_ret_type(number);
	l.luabase.push_string(@get_enum_name(res), 0);
	return 1;
}
fn int call(gmod::LuaState* l) {
	@is_function(l, 1);
	M3Function* arg = @get_function(l, 1);

	int args = l.luabase.top();
	uint wasmArgCount = arg.get_arg_count(); 
	if ((uint)args-1 != wasmArgCount) {
		l.luabase.throw_error("paramater count mismatch");
	}
	gmod_wasm::@log(l, "calling wasm function with %s args", wasmArgCount);
	ulong[] argBuf = mem::new_array(ulong, wasmArgCount);
	defer mem::free(argBuf);
	void*[] argPtrs = mem::new_array(void*, wasmArgCount);
	defer mem::free(argPtrs);
	for (int i = 0; i < (int)wasmArgCount; i += 1) {
		argPtrs[i]=&argBuf[i];
		M3ValueType t = arg.get_arg_type((uint)i);
		gmod_wasm::@log(l, "the stack under %s is %s", i+2, l.luabase.get_number(i+2));
		switch (t) {
			case I32:
				*((int*)argPtrs[i]) = (int)l.luabase.get_number(i+2);
			case I64:
				*((long*)argPtrs[i]) = (long)l.luabase.get_number(i+2);
			case F32:
				*((float*)argPtrs[i]) = (float)l.luabase.get_number(i+2);
			case F64:
				*((double*)argPtrs[i]) = l.luabase.get_number(i+2);
			// case FUNCREF:
			// 	@push_function(l, (M3Function*)arg);
			// 	break;
			default:
				gmod_wasm::@log(l, "unsupported arg! got %s", t);
		}
		
	}
	gmod_wasm::@log(l, "constructed args, %s", argPtrs);
	M3Result res = arg.call(argPtrs.len, argPtrs.ptr);
	if (res != null) {
		gmod_wasm::@log(l, "call failed!");
		l.luabase.throw_error(res);
	}
	gmod_wasm::@log(l, "call succeeded");
	uint retcount = arg.get_ret_count();

    ulong[] valbuff = mem::new_array(ulong, retcount);
	defer mem::free(valbuff);
    void*[] resultPtrs = mem::new_array(void*, retcount);
	defer mem::free(resultPtrs);
    for (uint i = 0; i < retcount; i++) {
        resultPtrs[i] = &valbuff[i];
    }
    res = arg.get_results(retcount, resultPtrs.ptr);
    if (res != null) {
		gmod_wasm::@log(l, "get results failed!");
		l.luabase.throw_error(res);
	}
	gmod_wasm::@log(l, "results: %s", resultPtrs);
	for (int i = 0; i < (int)retcount; i += 1) {
		M3ValueType t = arg.get_ret_type((uint)i);
		switch (t) {
			case I32:
				l.luabase.push_number((*(int*)resultPtrs[i]));
			case I64:
				l.luabase.push_number((*(long*)resultPtrs[i]));
			case F32:
				l.luabase.push_number((*(float*)resultPtrs[i]));
			case F64:
				l.luabase.push_number((*(double*)resultPtrs[i]));
			// case FUNCREF:
			// 	@push_function(l, (M3Function*)arg);
			// 	break;
			default:
				gmod_wasm::@log(l, "unsupported arg! got %s", t);
		}
	}
	return (int)retcount;
}
fn int get_function_name(gmod::LuaState* l) {
	@is_function(l, 1);
	M3Function* func = @get_function(l, 1);
	l.luabase.push_string(func.get_name());
	return 1;
}
fn int get_module(gmod::LuaState* l) {
	@is_function(l, 1);
	M3Function* func = @get_function(l, 1);
	M3Module* mod = func.get_module();
	@push_module(l, mod);
	return 1;
}
int function_type = 0;
fn void create_function_metatable(gmod::LuaState* l) {
	l.luabase.msg("[WASM] Creating metatable for M3Function\n");
	function_type = l.luabase.create_meta_table("M3Function*");
	@add_function(l, "GetArgCount", &get_arg_count);
	@add_function(l, "GetRetCount", &get_ret_count);
	@add_function(l, "GetArgType", &get_arg_type);
	@add_function(l, "GetRetType", &get_ret_type);
	@add_function(l, "Call", &call);
	@add_function(l, "__call", &call);
	@add_function(l, "GetName", &get_function_name);
	@add_function(l, "GetModule", &get_module);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Function successfully created\n");
}
fn int get_value(gmod::LuaState* l) {
	@is_global(l, 1);
	M3Global* global = @get_global(l, 1);
	M3TaggedValue value;
	M3Result res = global.get_value(&value);
	if (res == null) {
		switch (value.type) {
			case I32:
				l.luabase.push_number((double)value.value.i32);
				break; 
			case I64:
				l.luabase.push_number((double)value.value.i32);
				break; 
			case F32:
				l.luabase.push_number((double)value.value.f32);
				break; 
			case F64:
				l.luabase.push_number((double)value.value.f64);
				break; 
			case FUNCREF:
				if (value.value.ref == null) {
					l.luabase.push_nil();
					return 1;
				}
				@push_function(l, (M3Function*)value.value.ref);
				break;
			default:
				@push_error(l, "not supported type");
				return 2;
		}
		return 1;
	}
	@push_error(l, res);
	return 2;
}
fn int set_value(gmod::LuaState* l) {
	@is_global(l, 1);
	l.luabase.throw_error("not implemented");
}
fn int get_type(gmod::LuaState* l) {
	@is_global(l, 1);
	l.luabase.throw_error("not implemented");
}
int global_type = 0;
fn void create_global_metatable(gmod::LuaState* l) {
	l.luabase.msg("[WASM] Creating metatable for M3Global\n");
	global_type = l.luabase.create_meta_table("M3Global*");
	@add_function(l, "GetValue", &get_value);
	@add_function(l, "SetValue", &set_value);
	@add_function(l, "GetType", &get_type);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Global successfully created\n");
}

struct LuaM3MemView {
	M3Module* mod;
}

fn char[] LuaM3MemView.get_memory(LuaM3MemView self) {
	sz memorySize;
	char* ptr = self.mod.get_memory(&memorySize, 0); //always 0 in wasm3, may change in future 
	return ptr[:memorySize];
}
fn void LuaM3MemView.write(LuaM3MemView self, uint offset, void* ptr, uint len) { //max 4GB in wasm
	char[] mem = self.get_memory();
	char* mem_ptr = mem;
	mem::copy(mem_ptr+offset, ptr, len);
}
fn char[] LuaM3MemView.read(LuaM3MemView self, uint offset, uint len) {
	char[] mem = self.get_memory();
	return mem[offset:len];
}
fn String LuaM3MemView.read_string(LuaM3MemView self, uint offset) {
	ZString mem = (ZString)(char*)self.get_memory();
	return mem.str_view();
}
fn void write_value_to_memview(LuaM3MemView self, uint offset, Type value) <Type> {
	char* mem = (char*)self.get_memory();
	(*((Type*)(mem+offset))) = value;
}
fn Type read_value_from_memview(LuaM3MemView self, uint offset) <Type> {
	char* mem = (char*)self.get_memory();
	return *((Type*)mem);
}

macro void @push_memview(gmod::LuaState* l, LuaM3MemView memview) {
	l.luabase.create_table();
	l.luabase.push_string("__module");
	@push_module(l, memview.mod);
	l.luabase.push_meta_table(function_type);
    l.luabase.set_meta_table(-2);
}

macro LuaM3MemView @get_memview(gmod::LuaState* l, int stackPos) {
	l.luabase.get_field(1, "__module");
	return (LuaM3MemView){@get_module(l, -1)};
}
macro void @is_memview(gmod::LuaState* l, int stackPos) {
	l.luabase.get_field(1, "__module");
	l.luabase.check_type(-1, memview_type);
	l.luabase.pop();
}

fn int lua_memview_write(gmod::LuaState* l) <Type> {
	@is_memview(l, 1);
	LuaM3MemView memview = @get_memview(l, 1);
	uint offset = (uint)l.luabase.check_number(2);
	Type value = (Type)l.luabase.check_number(3);
	write_value_to_memview{Type}(memview, offset, value);
	return 0;
}
fn int lua_memview_read(gmod::LuaState* l) <Type> {
	@is_memview(l, 1);
	LuaM3MemView memview = @get_memview(l, 1);
	uint offset = (uint)l.luabase.check_number(2);
	l.luabase.push_number((Type)read_value_from_memview{Type}(memview, offset));
	return 0;
}
fn int lua_memview_read_string(gmod::LuaState* l) <Type> {
	@is_memview(l, 1);
	LuaM3MemView memview = @get_memview(l, 1);
	uint offset = (uint)l.luabase.check_number(2);
	if (l.luabase.is_type(3, (int)gmod::Types.NUMBER)) {
		uint len = (uint)l.luabase.check_number(3);
		char[] mem = memview.read(offset, len);
		l.luabase.push_string(mem, mem.len);
	} else {
		char* str = ((char*)memview.get_memory())+offset;
		l.luabase.push_string(str);
	}
	return 1;
}
fn int lua_memview_write_string(gmod::LuaState* l) {
	@is_memview(l, 1);
	@is_string(l, 3);
	LuaM3MemView memview = @get_memview(l, 1);
	uint offset = (uint)l.luabase.check_number(2);
	CInt len;
	char* value = (char*)l.luabase.get_string(3, &len);
	bool shouldPrintNull = false;
	if (l.luabase.is_type(4, (int)gmod::Types.BOOL)) {
		shouldPrintNull = l.luabase.get_bool(4);
	}
	if (shouldPrintNull) {
		len+=1; // lua guarntees last character after len will be \0
	}
	memview.write(offset, value, (uint)len);
	return 0;
}
int memview_type = 0;

fn void create_memory_view_metatable(gmod::LuaState* l) {
	l.luabase.msg("[WASM] Creating metatable for LuaM3MemView\n");
	global_type = l.luabase.create_meta_table("LuaM3MemView");
	@add_function(l, "WriteI8", &lua_memview_write{ichar});
	@add_function(l, "WriteI16", &lua_memview_write{short}); 
	@add_function(l, "WriteI32", &lua_memview_write{int});
	@add_function(l, "WriteI64", &lua_memview_write{long}); // precision loss! should we advocate not using this function?
	@add_function(l, "WriteU8", &lua_memview_write{char});
	@add_function(l, "WriteU16", &lua_memview_write{ushort});
	@add_function(l, "WriteU32", &lua_memview_write{uint});
	@add_function(l, "WriteU64", &lua_memview_write{ulong}); // see WriteI64
	@add_function(l, "WriteF32", &lua_memview_write{float});
	@add_function(l, "WriteF64", &lua_memview_write{double});
	@add_function(l, "WriteString", &lua_memview_write{double});
	@add_function(l, "ReadI8", &lua_memview_write{ichar});
	@add_function(l, "ReadI16", &lua_memview_write{short}); 
	@add_function(l, "ReadI32", &lua_memview_write{int});
	@add_function(l, "ReadI64", &lua_memview_write{long}); // precision loss! should we advocate not using this function?
	@add_function(l, "ReadU8", &lua_memview_write{char});
	@add_function(l, "ReadU16", &lua_memview_write{ushort});
	@add_function(l, "ReadU32", &lua_memview_write{uint});
	@add_function(l, "ReadU64", &lua_memview_write{ulong}); // see WriteI64
	@add_function(l, "ReadF32", &lua_memview_write{float});
	@add_function(l, "ReadF64", &lua_memview_write{double});
	@add_function(l, "ReadString", &lua_memview_write{double});
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for LuaM3MemView successfully created\n");
}