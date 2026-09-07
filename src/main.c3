module gmod_wasm;
import gmod;
import std::io;
import wasm3;

wasm3::IM3Environment wasm_env;
fn int open(LuaState* state) @export("gmod13_open") {
	wasm_env = wasm3::new_environment();
	// if (wasm_env == 0) {
	// 	lua_interface::msg(state.luabase, "failed to load wasm3 :(\n");
	// 	return -1;
	// }
	lua_interface::msg(state.luabase, "may the wasm be in your game\n");
	lua_base::create_table(state.luabase);

    lua_base::push_c_function(state.luabase, &lua::new_runtime);
    lua_base::set_field(state.luabase, -2, "NewRuntime" );

	lua_base::push_special(state.luabase, (int)gmod::Special.GLOBAL ); // Push the global table
	lua_base::push(state.luabase, -2);
	lua_base::set_field(state.luabase, -2, "wasm");
    lua_base::pop(state.luabase, 2); // Pop the global table off the stack
	return 0;
}

fn int close(LuaState state) @export("gmod13_close") {
	wasm3::free_environment(wasm_env);
	return 0;
}

