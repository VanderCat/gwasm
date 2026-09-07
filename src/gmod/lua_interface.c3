module gmod::lua_interface;

extern fn bool init(LuaInterface* self, LuaGameCallback* param0, bool param1) @cname("gmod__lua_interface__init");
extern fn void shutdown(LuaInterface* self) @cname("gmod__lua_interface__shutdown");
extern fn void cycle(LuaInterface* self) @cname("gmod__lua_interface__cycle");
extern fn LuaObject* global(LuaInterface* self) @cname("gmod__lua_interface__global");
extern fn LuaObject* get_object(LuaInterface* self, int index) @cname("gmod__lua_interface__get_object");
extern fn void push_lua_object(LuaInterface* self, LuaObject* obj) @cname("gmod__lua_interface__push_lua_object");
// lua_pushcclosure
extern fn void push_lua_function(LuaInterface* self, CFunc func) @cname("gmod__lua_interface__push_lua_function");
// luaL_argerror || engine.Msg()
// extern fn void lua_error(LuaInterface* self, char* err, int index) @cname("gmod__lua_interface__lua_error");
// luaL_typerror
// extern fn void type_error(LuaInterface* self, char* name, int index) @cname("gmod__lua_interface__type_error");
extern fn void call_internal(LuaInterface* self, int args, int rets) @cname("gmod__lua_interface__call_internal");
extern fn void call_internal_no_returns(LuaInterface* self, int args) @cname("gmod__lua_interface__call_internal_no_returns");
extern fn bool call_internal_get_bool(LuaInterface* self, int args) @cname("gmod__lua_interface__call_internal_get_bool");
extern fn char* call_internal_get_string(LuaInterface* self, int args) @cname("gmod__lua_interface__call_internal_get_string");
extern fn bool call_internal_get(LuaInterface* self, int args, LuaObject* obj) @cname("gmod__lua_interface__call_internal_get");
// lua_createtable + lua_setfield LUA_GLOBALSINDEX
extern fn void new_global_table(LuaInterface* self, char* name) @cname("gmod__lua_interface__new_global_table");
extern fn LuaObject* new_temporary_object(LuaInterface* self) @cname("gmod__lua_interface__new_temporary_object");
// lua_type == 7
extern fn bool is_user_data(LuaInterface* self, int index) @cname("gmod__lua_interface__is_user_data");
extern fn LuaObject* get_meta_table_object_ex(LuaInterface* self, char* name, int type) @cname("gmod__lua_interface__get_meta_table_object_ex");
extern fn LuaObject* get_meta_table_object(LuaInterface* self, int index) @cname("gmod__lua_interface__get_meta_table_object");
extern fn LuaObject* get_return(LuaInterface* self, int index) @cname("gmod__lua_interface__get_return");
// m_iRealm == State::SERVER;
extern fn bool is_server(LuaInterface* self) @cname("gmod__lua_interface__is_server");
// m_iRealm == State::CLIENT;
extern fn bool is_client(LuaInterface* self) @cname("gmod__lua_interface__is_client");
// m_iRealm == State::MENU;
extern fn bool is_menu(LuaInterface* self) @cname("gmod__lua_interface__is_menu");
extern fn void destroy_object(LuaInterface* self, LuaObject* obj) @cname("gmod__lua_interface__destroy_object");
extern fn LuaObject* create_object(LuaInterface* self) @cname("gmod__lua_interface__create_object");
extern fn void set_member(LuaInterface* self, LuaObject* table, LuaObject* key, LuaObject* value) @cname("gmod__lua_interface__set_member");
extern fn LuaObject* get_new_table(LuaInterface* self) @cname("gmod__lua_interface__get_new_table");
extern fn void set_member_i(LuaInterface* self, LuaObject* table, float key) @cname("gmod__lua_interface__set_member_i");
extern fn void set_member_i_ex(LuaInterface* self, LuaObject* table, float key, LuaObject* value) @cname("gmod__lua_interface__set_member_i_ex");
extern fn void set_member_k(LuaInterface* self, LuaObject* table, char* key) @cname("gmod__lua_interface__set_member_k");
extern fn void set_member_kex(LuaInterface* self, LuaObject* table, char* key, LuaObject* value) @cname("gmod__lua_interface__set_member_kex");
// m_iRealm = realm;
extern fn void set_type(LuaInterface* self, char param0) @cname("gmod__lua_interface__set_type");
// lua_pushnumber
extern fn void push_long(LuaInterface* self, long num) @cname("gmod__lua_interface__push_long");
// lua_tonumber (?)
extern fn int get_flags(LuaInterface* self, int index) @cname("gmod__lua_interface__get_flags");
extern fn bool find_on_objects_meta_table(LuaInterface* self, int objIndex, int keyIndex) @cname("gmod__lua_interface__find_on_objects_meta_table");
extern fn bool find_object_on_table(LuaInterface* self, int tableIndex, int keyIndex) @cname("gmod__lua_interface__find_object_on_table");
extern fn void set_member_fast(LuaInterface* self, LuaObject* table, int keyIndex, int valueIndex) @cname("gmod__lua_interface__set_member_fast");
// RunStringEx(filename, path, stringToRun, run, showErrors, true, true);
extern fn bool run_string(LuaInterface* self, char* filename, char* path, char* stringToRun, bool run, bool showErrors) @cname("gmod__lua_interface__run_string");
extern fn bool is_equal(LuaInterface* self, LuaObject* objA, LuaObject* objB) @cname("gmod__lua_interface__is_equal");
// luaL_error
// extern fn void error(LuaInterface* self, char* err) @cname("gmod__lua_interface__error");
// lua_tolstring || luaL_error
// extern fn char* get_string_or_error(LuaInterface* self, int index) @cname("gmod__lua_interface__get_string_or_error");
// find_and_run_script("includes/modules/%s.lua", true, true, "", true);
extern fn bool run_lua_module(LuaInterface* self, char* name) @cname("gmod__lua_interface__run_lua_module");
extern fn bool find_and_run_script(LuaInterface* self, char* filename, bool run, bool showErrors, char* stringToRun, bool noReturns) @cname("gmod__lua_interface__find_and_run_script");
extern fn void set_path_id(LuaInterface* self, char* pathID) @cname("gmod__lua_interface__set_path_id");
extern fn char* get_path_id(LuaInterface* self) @cname("gmod__lua_interface__get_path_id");
// Msg("An error ocurred! %s\n")
// extern fn void error_no_halt(LuaInterface* self, char* fmt) @cname("gmod__lua_interface__error_no_halt");
// m_pGameCallback->Msg(buffer, false); TODO: should be vararg
extern fn void msg(LuaInterface* self, char* fmt) @cname("gmod__lua_interface__msg");
extern fn void push_path(LuaInterface* self, char* path) @cname("gmod__lua_interface__push_path");
extern fn void pop_path(LuaInterface* self) @cname("gmod__lua_interface__pop_path");
extern fn char* get_path(LuaInterface* self) @cname("gmod__lua_interface__get_path");
extern fn int get_color(LuaInterface* self, int index) @cname("gmod__lua_interface__get_color");
// void* push_color(LuaInterface* self, Color color);
// lua_getstack
// int get_stack(LuaInterface* self, int level, lua_Debug* dbg);
// lua_getinfo
// int get_info(LuaInterface* self, char* what, lua_Debug* dbg);
// lua_getlocal
extern fn char* get_local(LuaInterface* self, LuaDebug* dbg, int n) @cname("gmod__lua_interface__get_local");
// lua_getupvalue
extern fn char* get_upvalue(LuaInterface* self, int funcIndex, int n) @cname("gmod__lua_interface__get_upvalue");
extern fn bool run_string_ex(LuaInterface* self, char* filename, char* path, char* stringToRun, bool run, bool printErrors, bool dontPushErrors, bool noReturns) @cname("gmod__lua_interface__run_string_ex");
// lua_tolstring
extern fn sz get_data_string(LuaInterface* self, int index, char** str) @cname("gmod__lua_interface__get_data_string");
extern fn void error_from_lua(LuaInterface* self, char* fmt) @cname("gmod__lua_interface__error_from_lua");
extern fn char* get_current_location(LuaInterface* self) @cname("gmod__lua_interface__get_current_location");
// TODO: vararg
extern fn void msg_colour(LuaInterface* self, Color* col, char* fmt) @cname("gmod__lua_interface__msg_colour");
// void get_current_file(LuaInterface* self, char** outStr);
//BORKED:
// extern fn bool compile_string(LuaInterface* self, Buffer* dumper, char* stringToCompile) @cname("gmod__lua_interface__compile_string");
// pcall with check
extern fn bool call_function_protected(LuaInterface* self, int param0, int param1, bool param2) @cname("gmod__lua_interface__call_function_protected");
// run dll from lua/bin or .lua file
extern fn void require(LuaInterface* self, char* name) @cname("gmod__lua_interface__require");
// luaL_typename
extern fn char* get_actual_type_name(LuaInterface* self, int type) @cname("gmod__lua_interface__get_actual_type_name");
// lua_createtable
extern fn void pre_create_table(LuaInterface* self, int arrelems, int nonarrelems) @cname("gmod__lua_interface__pre_create_table");
extern fn void push_pooled_string(LuaInterface* self, int index) @cname("gmod__lua_interface__push_pooled_string");
extern fn char* get_pooled_string(LuaInterface* self, int index) @cname("gmod__lua_interface__get_pooled_string");
extern fn int add_threaded_call(LuaInterface* self, LuaThreadedCall* call) @cname("gmod__lua_interface__add_threaded_call");
extern fn void append_stack_trace(LuaInterface* self, char* param0, uint param1) @cname("gmod__lua_interface__append_stack_trace");
extern fn ConVar* create_con_var(LuaInterface* self, char* name, char* defaultValue, char* helpString, int flags) @cname("gmod__lua_interface__create_con_var");
alias ConCommandCallback = fn void ( CCommand* command );
extern fn ConCommand* create_con_command(LuaInterface* self, char* name, char* helpString, int flags, ConCommandCallback callback) @cname("gmod__lua_interface__create_con_command");
extern fn char* check_string_opt(LuaInterface* self, int iStackPos, char* def) @cname("gmod__lua_interface__check_string_opt");
extern fn double check_number_opt(LuaInterface* self, int iStackPos, double def) @cname("gmod__lua_interface__check_number_opt");
extern fn int register_meta_table(LuaInterface* self, char* name, LuaObject* tbl) @cname("gmod__lua_interface__register_meta_table");