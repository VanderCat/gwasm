module gmod_wasm::lua;

import gmod;
import wasm3;

extern fn void* lua_newuserdata(gmod::LuaState* l, sz size);
int runtime_type = 0;

fn int new_runtime(gmod::LuaState* l) {
    lua_base::check_number(l.luabase, 1);
	uint i_stackSizeInBytes = (uint)lua_base::get_number(l.luabase, 1);
    void** ptr = (void**)lua_newuserdata(l, uptr::size);
	
	IM3Runtime runtime = wasm3::new_runtime(gmod_wasm::wasm_env, i_stackSizeInBytes, (void*)ptr);
	lua_base::push_meta_table(l.luabase, runtime_type);
    lua_base::set_meta_table(l.luabase, -2);
	*ptr = runtime;
	return 1;
}

fn int free_runtime(gmod::LuaState* l) {
	lua_base::check_type(l.luabase, 1, runtime_type);
	// int udata = lua_base::check_number(l.luabase, 1);
	// if (udata == 0) {
	// 	lua_base::arg_error(l.luabase, 1, "`IM3Runtime` expected")
	// 	return 0;
	// }
	//wasm3::free_runtime(udata);
	return 0;
}

fn void create_runtime_metatable(gmod::LuaState* l) {
	runtime_type = lua_base::create_meta_table(l.luabase, "IM3Runtime");
}