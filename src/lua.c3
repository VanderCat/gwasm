module gmod_wasm::lua;

import gmod;
import wasm3;

macro luaL_getmetatable(gmod::LuaState* l, char* n) {
	return l.luabase.get_field(gmod::Index.REGISTRY, (n));
}


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
macro @is_string(gmod::LuaState* l, int stackPos) {
	l.luabase.check_type(stackPos, (int)gmod::Types.STRING);
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
	@is_string(l, 2);
	M3Runtime* runtime = @get_runtime(l, 1);
	char* str = l.luabase.get_string(2, null);
	M3Module* mod = runtime.find_module(str);
	// TODO: return module
	return 0;
}
fn int get_error_info(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
	M3ErrorInfo info;
	runtime.get_error_info(&info);
	l.luabase.create_table();
	l.luabase.push_string(info.result, 0);
	l.luabase.set_field(-2, "result");
	l.luabase.push_string(info.file, 0);
	l.luabase.set_field(-2, "file");
	l.luabase.push_string(info.message, 0);
	l.luabase.set_field(-2, "message");
	l.luabase.push_number(info.line);
	l.luabase.set_field(-2, "line");
	//TODO: other fields
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
	@add_function(l, "SetGasLimit", &set_gas_limit);
	@add_function(l, "GetErrorInfo", &get_error_info);
	@add_function(l, "ResetErrorInfo", &reset_error_info);
	@add_function(l, "GetBacktrace", &get_backtrace);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Runtime* successfully created\n");
}
fn int module_free(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_memory(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int set_memory_size(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int find_exported_memory(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int bind_import_memory(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int run_start(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int compile(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int link_raw_function(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int link_global(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_name(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int set_name(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_runtime(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int find_function_in(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_table_function(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
int module_type = 0;
fn void create_module_metatable(gmod::LuaState* l) {
	l.luabase.msg("[WASM] Creating metatable for M3Module\n");
	global_type = l.luabase.create_meta_table("M3Module*");
	@add_function(l, "__gc", &module_free);
	@add_function(l, "GetMemory", &get_memory);
	@add_function(l, "SetMemorySize", &set_memory_size);
	@add_function(l, "FindExportedMemory", &find_exported_memory);
	@add_function(l, "BindImportMemory", &bind_import_memory);
	@add_function(l, "FindExportedMemory", &find_exported_memory);
	@add_function(l, "RunStart", &run_start);
	@add_function(l, "Compile", &compile);
	@add_function(l, "LinkFunction", &link_raw_function);
	@add_function(l, "LinkGlobal", &link_global);
	@add_function(l, "GetName", &get_name);
	@add_function(l, "SetName", &set_name);
	@add_function(l, "GetRuntime", &get_runtime);
	@add_function(l, "FindFunction", &find_function_in);
	@add_function(l, "GetTableFunction", &get_table_function);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Module successfully created\n");
}
fn int get_arg_count(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_ret_count(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_arg_type(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_ret_type(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int call(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_function_name(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_module(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
int function_type = 0;
fn void create_function_metatable(gmod::LuaState* l) {
	l.luabase.msg("[WASM] Creating metatable for M3Function\n");
	global_type = l.luabase.create_meta_table("M3Function*");
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
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int set_value(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int get_type(gmod::LuaState* l) {
	l.luabase.throw_error("not implemented");
	return 0;
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