module gmod_wasm::lua;

import gmod;
import wasm3;

macro luaL_getmetatable(gmod::LuaState* l, char* n) {
	return l.luabase.get_field(gmod::Index.REGISTRY, (n));
}
int runtime_type = 0;

fn int new_runtime(gmod::LuaState* l) {
    l.luabase.check_number(1);
	uint i_stackSizeInBytes = (uint)l.luabase.get_number(1);
    // void** ptr = (void**)l.luabase.new_userdata(uptr::size);
	
	M3Runtime* runtime = gmod_wasm::wasm_env.new_runtime(i_stackSizeInBytes, null); //TODO: userdata as handle?
	l.luabase.push_user_type(runtime, runtime_type);
	l.luabase.push_meta_table(runtime_type);
    l.luabase.set_meta_table(-2);
	return 1;
}
macro @is_runtime(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, runtime_type);
}
macro @is_bool(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, (int)gmod::Types.BOOL);
}
macro @get_runtime(gmod::LuaState* l, int stackPos) {
	return (M3Runtime*)l.luabase.get_user_type(stackPos, runtime_type);
}
fn int free_runtime(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	runtime.free_runtime();
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
	return 0;
}
fn int get_gas_limit(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}
fn int get_gas_used(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}
fn int load_module(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}
fn int find_function(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}
fn int find_module(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}
fn int get_error_info(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}
fn int reset_error_info(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}
fn int get_backtrace(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	return 0;
}

macro @add_function(gmod::LuaState* l, char* name, func) {
	l.luabase.push_c_function(func); 
	l.luabase.set_field(-2, name);
}

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
	@add_function(l, "SetGasLimit", &set_gas_limit);
	@add_function(l, "GetErrorInfo", &get_error_info);
	@add_function(l, "ResetErrorInfo", &reset_error_info);
	@add_function(l, "GetBacktrace", &get_backtrace);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Runtime* successfully created\n");
}