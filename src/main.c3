module gmod_wasm;
import gmod;
import std::io;
import wasm3;

wasm3::M3Environment* wasm_env;
fn int open(LuaState* state) @export("gmod13_open") {
	wasm_env = wasm3::new_environment();
	// if (wasm_env == 0) {
	// 	lstate.luabase.msg("failed to load wasm3 :(\n");
	// 	return -1;
	// }
	state.luabase.msg("may the wasm be in your game\n");
	lua::create_metatables(state);
	state.luabase.create_table();

    state.luabase.push_c_function(&lua::new_runtime);
    state.luabase.set_field(-2, "NewRuntime" );
	state.luabase.push_c_function(&lua::yield);
    state.luabase.set_field(-2, "Yield" );
	state.luabase.push_c_function(&lua::parse_module);
    state.luabase.set_field(-2, "ParseModule" );

	state.luabase.push_special((int)gmod::Special.GLOBAL ); // Push the global table
	state.luabase.push(-2);
	state.luabase.set_field(-2, "wasm");
    state.luabase.pop(2); // Pop the global table off the stack
	return 0;
}

fn int close(LuaState state) @export("gmod13_close") {
	wasm_env.free();
	return 0;
}

