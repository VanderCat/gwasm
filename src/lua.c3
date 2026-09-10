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

macro luaL_getmetatable(gmod::LuaState* l, char* n) {
	return l.luabase.get_field(gmod::Index.REGISTRY, (n));
}

macro @push_runtime(gmod::LuaState* l, M3Runtime* runtime) {
	((M3RuntimeUserdata*)runtime.get_user_data()).referenceCount += 1;
	l.luabase.push_user_type(runtime, runtime_type);
	l.luabase.push_meta_table(runtime_type);
    l.luabase.set_meta_table(-2);
}
macro @push_module(gmod::LuaState* l, M3Module* module_) {
	l.luabase.push_user_type(module_, module_type);
	l.luabase.push_meta_table(module_type);
    l.luabase.set_meta_table(-2);
}
macro @push_function(gmod::LuaState* l, M3Function* func) {
	l.luabase.push_user_type(func, function_type);
	l.luabase.push_meta_table(function_type);
    l.luabase.set_meta_table(-2);
}
macro @push_global(gmod::LuaState* l, M3Global* global) {
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
    // void** ptr = (void**)l.luabase.new_userdata(uptr::size);
	M3RuntimeUserdata* userdata = mem::new(M3RuntimeUserdata);
	userdata.state = l;
	userdata.referenceCount = 1;
	M3Runtime* runtime = gmod_wasm::wasm_env.new_runtime(i_stackSizeInBytes, l);
	userdata.runtime = runtime;
	@push_runtime(l, runtime);
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
macro @get_runtime(gmod::LuaState* l, int stackPos) {
	return (M3Runtime*)l.luabase.get_user_type(stackPos, runtime_type);
}
macro @get_module(gmod::LuaState* l, int stackPos) {
	return (M3Module*)l.luabase.get_user_type(stackPos, module_type);
}
macro @get_function(gmod::LuaState* l, int stackPos) {
	return (M3Function*)l.luabase.get_user_type(stackPos, function_type);
}
macro @get_global(gmod::LuaState* l, int stackPos) {
	return (M3Global*)l.luabase.get_user_type(stackPos, global_type);
}
fn int free_runtime(gmod::LuaState* l) {
	@is_runtime(l, 1);
	M3Runtime* runtime = @get_runtime(l, 1);
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
	l.luabase.create_table();
	l.luabase.push_string(info.result, 0);
	l.luabase.set_field(-2, "result");
	l.luabase.push_string(info.file, 0);
	l.luabase.set_field(-2, "file");
	l.luabase.push_string(info.message, 0);
	l.luabase.set_field(-2, "message");
	l.luabase.push_number(info.line);
	l.luabase.set_field(-2, "line");
	@push_module(l, info.module_);
	l.luabase.set_field(-2, "module");
	@push_runtime(l, info.runtime);
	l.luabase.set_field(-2, "runtime");
	@push_function(l, info.function);
	l.luabase.set_field(-2, "function");
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
	@add_function(l, "GetErrorInfo", &get_error_info);
	@add_function(l, "ResetErrorInfo", &reset_error_info);
	@add_function(l, "GetBacktrace", &get_backtrace);
	l.luabase.set_field(-1, "__index");
	l.luabase.msg("[WASM] Metatable for M3Runtime* successfully created\n");
}
fn int module_free(gmod::LuaState* l) {
	@is_module(l, 1);
	@get_module(l, 1).free();
	return 0;
}
fn int get_memory(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int set_memory_size(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int find_exported_memory(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int bind_import_memory(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.throw_error("not implemented");
	return 0;
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
fn void* rawfunc(M3Runtime* runtime, M3ImportContext* _ctx, ulong* _sp, void* _mem) {
	gmod::LuaState* l = runtime.get_user_data();
	uint iArgs = _ctx.function.get_arg_count();
	uint iRets = _ctx.function.get_ret_count();
	for (uint i = 1; i < iArgs; i += 1) {
		void* arg = (void*)_sp[iRets+i];
		M3ValueType type = _ctx.function.get_arg_type(i);
		switch (type) {
			case I32:
				l.luabase.push_number(*(int*)arg);
				break;
			case I64:
				l.luabase.push_number(*(long*)arg);
				break;
			case F32:
				l.luabase.push_number(*(float*)arg);
				break;
			case F64:
				l.luabase.push_number(*(double*)arg);
				break;
			case FUNCREF:
				@push_function(l, (M3Function*)arg);
				break;
			default:
				l.luabase.msg("unknown arg! got TODO");
				//l.luabase.msg(type.description());
				l.luabase.msg("\n");
				break;
		}
	}
	l.luabase.reference_push((int)(iptr)_ctx.userdata);
	l.luabase.call((int)iArgs, (int)iRets);
	for (uint i = 1; i < iRets; i += 1) {
		void* arg = (void*)_sp[iRets+i];
		M3ValueType type = _ctx.function.get_ret_type(i);
		switch (type) {
			case I32:
				(*(int*)arg) = (int)l.luabase.get_number((int)i);
				break;
			case I64:
				(*(long*)arg) = (long)l.luabase.get_number((int)i);
				break;
			case F32:
				(*(float*)arg) = (float)l.luabase.get_number((int)i);
				break;
			case F64:
				(*(double*)arg) = l.luabase.get_number((int)i);
				break;
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
	@is_function(l, 5);
	M3Module* mod = @get_module(l, 1);
	char* moduleName = l.luabase.get_string(2, null);
	char* functionName = l.luabase.get_string(3, null);
	char* signature = l.luabase.get_string(4, null);
	int funcRef = l.luabase.reference_create();
	M3Result result = mod.link_raw_function_ex(moduleName, functionName, signature, &rawfunc, (void*)(iptr)funcRef);
	if (result == null) {
		l.luabase.throw_error(result);
	}
	return 0;
}
fn int link_global(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.throw_error("not implemented");
	return 0;
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
	l.luabase.throw_error("not implemented");
	return 0;
}
fn int find_global(gmod::LuaState* l) {
	@is_module(l, 1);
	l.luabase.throw_error("not implemented");
	return 0;
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
	@add_function(l, "SetMemorySize", &set_memory_size);
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
	l.luabase.throw_error("not implemented");
	return 0;
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
	return 0;
}
fn int get_type(gmod::LuaState* l) {
	@is_global(l, 1);
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