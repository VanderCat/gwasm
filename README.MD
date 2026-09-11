# Garry's Mod WASM support
!! Not finished nor tested !!

Adds ability to run WebAssembly inside GMod, allowing you to run stuff that normally would require poring to lua, e.g. physics engines, etc.

You could probably embed other scripting runtimes to gmod this way! Ever wanted to make addons in python? ~~(please consider quitting modding if that what you actually want)~~

This is _raw_ bindings to WASM3, no WASI, no libc, etc. This would probably come later in lua side.

example:
```lua
require "wasm" -- creates wasm env and loads the dll

local runtime = wasm.CreateRuntime()
local module = runtime:LoadModule(wasm.ParseModule(file.Read("wasm/name.wasm", "GAME")))
module:LinkFunction("Lua", "print", "v(**)", function(...) print(...) end)
module:RunStart() -- will launch the entry point, optional
local add = module:FindFunction("add")
local result = add(2, 4)
print(result)
```