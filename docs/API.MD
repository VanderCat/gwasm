Load library
```lua
require wasm
```

# `wasm` global
```lua
wasm.NewRuntime(stack: int): M3Runtime
```
```lua
wasm.ParseModule(wasmBytes: string): M3Module
```
```lua
wasm.Yield()
```
# M3Runtime
```lua
M3Runtime:SetValidation(enabe: bool)
```
The validator runs as a pre-pass of compiling a function body, so it follows lazy compilation: a body is checked the first time it is compiled.

Turning it off means trusting the module - nothing then checks a body's types before it runs. On by default.

```lua
M3Runtime:SetGasLimit(gas: number)
```
Gas metering. Arming a runtime with a gas budget makes the compiler instrument the function bodies it compiles from then on: each straight-line segment of a body is charged, before any of it runs, for the instructions it is about to execute. Running the budget out throws error, which no amount of Wasm can catch, so this bounds how long a module can run as well as how much it can do.

Costs come from ewasm's metering design, whose unit is a ten-thousandth of a gas - hence the fractional gas these speak in. Instrumentation follows lazy compilation, so a body already compiled when the limit is set is not metered: arm the runtime before running anything. Setting a new limit re-arms the runtime with a full budget, and does not recompile what is already compiled.

The gas used can exceed the limit by the cost of the segment that ran out - it is charged in full before the trap.
```lua
M3Runtime:GetGasLimit(): number
```
see SetGasLimit
```lua
M3Runtime:GetGasUsed(): number
```
see SetGasLimit
```lua
M3Runtime:LoadModule(mod: M3Module)
```
Transfers ownership of the module to the runtime - whether or not it succeeds. A failed instantiation can already have written this module's functions into a table another module owns, and the spec keeps whatever it managed to do, so those entries stay callable.
```lua
M3Runtime:FindModule(moduleName: string): M3Module?
```
The module registered under `moduleName`, or `nil`. Most recently loaded first, so a name registered twice names the newer module.
```lua
M3Runtime:FindFunction(name: string): M3Function?, error?
```
Searches every module loaded into the runtime, most recently loaded first.
```lua
M3Runtime:GetErrorInfo(): table
```
```lua
{
    result: string,
    file: string,
    message: string,
    line: number,
    module: M3Module,
    runtime: M3Runtime,
    function: M3Function
}
```
```lua
M3Runtime:ResetErrorInfo()
```
```lua
M3Runtime:GetBacktrace(): table
```
TODO: NOT IMPLEMENTED

# M3Module
```lua
M3Module:GetMemory()
```
TODO: NOT IMPLEMENTED, should we split to `GetMemory(type: string, uint index): any?` and `SetMemory(type: string, uint index, value): any?` for sandboxing reasons and due to no pointer support in lua?

A memory belongs to the module that declares it, so this take the module rather than the runtime - a runtime can hold several modules, each with its own memories. Returns `nil` when the module has no memory at that index.
```lua
M3Module:GetMemorySize(index: number): number
```

```lua
M3Module:FindExportedMemory(name: string): uint
```
TODO: NOT IMPLEMENTED
The index of the memory the module exports under name. A host module whose ABI names the memory it addresses looks it up this way - WASI names it "memory". thows when no memory is exported.
```lua
M3Module:BindImportMemory()
```
TODO: NOT IMPLEMENTED
Pin which of the module's memories the host functions imported from importModule address(`"*"` for every namespace, as in `LinkRawFunction`). Applies to imports already bound to a host function, so call it after linking them. Left alone, a host function addresses memory 0 - what a bare i32 guest pointer means when nothing says otherwise - so this is only needed by a host module that names a memory.
```lua
M3Module:RunStart()
```
Calling this is optional.
```lua
M3Module:Compile()
```
Optional, compiles all functions in the module
```lua
M3Module:LinkFunction(moduleName: string, functionName: string, signature: string, func: function())
```
TODO: NOT IMPLEMENTED
```lua
M3Module:LinkGlobal() &link_global
```
TODO: NOT IMPLEMENTED
supplies the value of an imported global, regardless of its mutability
```lua
M3Module:GetName(): string
```
```lua
M3Module:SetName(name: string)
```
```lua
M3Module:GetRuntime(): M3Runtime
```
```lua
M3Module:FindGlobal(name: string): M3Global
```
```lua
M3Module:FindFunction(name: string): M3Function? error?
```
Searches just the one, which is what naming a module's export means.
```lua
M3Module:GetTableFunction(index: number): M3Function?, error?
```

# M3Function
```lua
M3Function:GetArgCount(): number
```
```lua
M3Function:GetRetCount(): number
```
```lua
M3Function:GetArgType(): string
```
```lua
M3Function:GetRetType(): string
```
```lua
M3Function:Call(...): ...
```
TODO: NOT IMPLEMENTED
```lua
M3Function(...): ...
```
alias to `M3Function:Call(...)`
```lua
M3Function:GetName():string
```
```lua
M3Function:GetModule()
```

# M3Global
```lua
M3Global:GetValue()
```
TODO: test
```lua
M3Global:SetValue()
```
TODO: NOT IMPLEMENTED
```lua
M3Global:GetType()
```
TODO: NOT IMPLEMENTED