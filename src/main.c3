module gmod_wasm;
import gmod;
import std::io;
import wasm3;

macro @log(gmod::LuaState* l, String fmt, args...) {
	String logstr = std::core::string::tformat("[WASM3] %s (%s:%d): %s\n", $$FUNC, $$FILE, $$LINE, fmt);
	String format = std::core::string::tformat(logstr, ...args);
	l.luabase.msg(format.zstr_tcopy());
}

wasm3::M3Environment* wasm_env;
fn int open(LuaState* state) @export("gmod13_open") {
	@log(state, "start");
	defer @log(state, "end");
	wasm_env = wasm3::new_environment();
	@log(state, "environment created");
	// if (wasm_env == 0) {
	// 	lstate.luabase.msg("failed to load wasm3 :(\n");
	// 	return -1;
	// }
	state.luabase.msg("may the wasm be in your game\n");
	lua::create_metatables(state);
	@log(state, "metatables created");
	state.luabase.create_table();

    state.luabase.push_c_function(&lua::new_runtime);
    state.luabase.set_field(-2, "NewRuntime" );
	state.luabase.push_c_function(&lua::yield);
    state.luabase.set_field(-2, "Yield" );
	state.luabase.push_c_function(&lua::parse_module);
    state.luabase.set_field(-2, "ParseModule" );
	
	@log(state, "wasm.* functions added");

	state.luabase.push_special((int)gmod::Special.GLOBAL ); // Push the global table
	state.luabase.push(-2);
	state.luabase.set_field(-2, "wasm");
    state.luabase.pop(2); // Pop the global table off the stack
	@log(state, "wasm global created");
	return 0;
}

fn int close(LuaState* state) @export("gmod13_close") {
	@log(state, "closing wasm");
	defer @log(state, "wasm closed");
	wasm_env.free();
	return 0;
}

