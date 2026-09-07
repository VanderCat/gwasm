module gmod::lua_base;
// lua_gettop
extern fn int top(gmod::LuaBase* self) @cname("gmod__lua_base__top");
// lua_pushvalue
extern fn void push(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__push");
// lua_pop
extern fn void pop(gmod::LuaBase* self, int iAmt) @cname("gmod__lua_base__pop");
// lua_gettable
extern fn void get_table(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_table");
// lua_getfield
extern fn void get_field(gmod::LuaBase* self, int iStackPos, char* strName) @cname("gmod__lua_base__get_field");
// lua_setfield
extern fn void set_field(gmod::LuaBase* self, int iStackPos, char* strName) @cname("gmod__lua_base__set_field");
// lua_createtable
extern fn void create_table(gmod::LuaBase* self) @cname("gmod__lua_base__create_table");
// lua_settable
extern fn void set_table(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__set_table");
// lua_setmetatable
extern fn void set_meta_table(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__set_meta_table");
// lua_getmetatable != 0
extern fn bool get_meta_table(gmod::LuaBase* self, int i) @cname("gmod__lua_base__get_meta_table");
// lua_call
extern fn void call(gmod::LuaBase* self, int iArgs, int iResults) @cname("gmod__lua_base__call");
// lua_pcall
extern fn int p_call(gmod::LuaBase* self, int iArgs, int iResults, int iErrorFunc) @cname("gmod__lua_base__p_call");
// lua_equal
extern fn int equal(gmod::LuaBase* self, int iA, int iB) @cname("gmod__lua_base__equal");
// lua_rawequal
extern fn int raw_equal(gmod::LuaBase* self, int iA, int iB) @cname("gmod__lua_base__raw_equal");
// lua_insert
extern fn void insert(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__insert");
// lua_remove
extern fn void remove(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__remove");
// lua_next
extern fn int next(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__next");
// luaL_error
extern fn void throw_error(gmod::LuaBase* self, char* strError) @cname("gmod__lua_base__throw_error");
// custom
extern fn void check_type(gmod::LuaBase* self, int iStackPos, int iType) @cname("gmod__lua_base__check_type");
// luaL_argerror
extern fn void arg_error(gmod::LuaBase* self, int iArgNum, char* strMessage) @cname("gmod__lua_base__arg_error");
// lua_rawget
extern fn void raw_get(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__raw_get");
// lua_rawset
extern fn void raw_set(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__raw_set");
// lua_tolstring
extern fn char* get_string(gmod::LuaBase* self, int iStackPos, CInt* iOutLen) @cname("gmod__lua_base__get_string");
// lua_tonumber
extern fn double get_number(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_number");
// lua_toboolean
extern fn bool get_bool(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_bool");
// lua_tocfunction
extern fn CFunc get_c_function(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_c_function");
// lua_touserdata
//extern fn void* get_user_data(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_user_data");
//lua_pushnil
extern fn void push_nil(gmod::LuaBase* self) @cname("gmod__lua_base__push_nil");
// lua_pushlstring or lua_pushlstring if ilen == 0
extern fn void push_string(gmod::LuaBase* self, char* val, CInt iLen) @cname("gmod__lua_base__push_string");
// lua_pushnumber
extern fn void push_number(gmod::LuaBase* self, double val) @cname("gmod__lua_base__push_number");
// lua_pushboolean
extern fn void push_bool(gmod::LuaBase* self, bool val) @cname("gmod__lua_base__push_bool");
// lua_pushcclosure
extern fn void push_c_function(gmod::LuaBase* self, CFunc val) @cname("gmod__lua_base__push_c_function");
// lua_pushcclosure
extern fn void push_c_closure(gmod::LuaBase* self, CFunc val, int iVars) @cname("gmod__lua_base__push_c_closure");
// lua_pushlightuserdata
// extern fn void push_user_data(gmod::LuaBase* self, void* val) @cname("gmod__lua_base__get_user_data");
// luaL_ref LUA_REGISTRYINDEX
extern fn int reference_create(gmod::LuaBase* self) @cname("gmod__lua_base__reference_create");
// luaL_unref LUA_REGISTRYINDEX
extern fn void reference_free(gmod::LuaBase* self, int i) @cname("gmod__lua_base__reference_free");
// lua_rawgeti LUA_REGISTRYINDEX
extern fn void reference_push(gmod::LuaBase* self, int i) @cname("gmod__lua_base__reference_push");
// lua_pushvalue || lua_pushnil
extern fn void push_special(gmod::LuaBase* self, int iType) @cname("gmod__lua_base__push_special");
// (lua_type + custom) == iType
extern fn bool is_type(gmod::LuaBase* self, int iStackPos, int iType) @cname("gmod__lua_base__is_type");
// lua_type + custom
extern fn int get_type(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_type");
// custom
extern fn char* get_type_name(gmod::LuaBase* self, int iType) @cname("gmod__lua_base__get_type_name");
// luaL_checklstring
extern fn char* check_string(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__check_string");
// luaL_checknumber
extern fn double check_number(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__check_number");
// lua_objlen
extern fn int obj_len(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__obj_len");
// custom
extern fn QAngle* get_angle(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_angle");
// custom
extern fn Vector* get_vector(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_vector");
// custom
extern fn void push_angle(gmod::LuaBase* self, QAngle* val) @cname("gmod__lua_base__push_angle");
// custom
extern fn void push_vector(gmod::LuaBase* self, Vector* val) @cname("gmod__lua_base__push_vector");
// custom
extern fn void set_state(gmod::LuaBase* self, LuaState* l) @cname("gmod__lua_base__set_state");
// luaL_newmetatable_type?
// Pushes the metatable associated with the given type name
// Returns the type ID to use for this type
// If the type doesn't currently exist, it will be created
extern fn int create_meta_table(gmod::LuaBase* self, char* strName) @cname("gmod__lua_base__create_meta_table");
// custom
// Pushes the metatable associated with the given type
extern fn bool push_meta_table(gmod::LuaBase* self, int iType) @cname("gmod__lua_base__push_meta_table");
// custom
extern fn void push_user_type(gmod::LuaBase* self, void* data, int iType) @cname("gmod__lua_base__push_user_type");
// custom
extern fn void set_user_type(gmod::LuaBase* self, int iStackPos, void* data) @cname("gmod__lua_base__set_user_type");
// custom
extern fn void* get_user_type(gmod::LuaBase* self, int iStackPos, int iType) @cname("gmod__lua_base__get_user_type");
//BORKED:
extern fn void** new_user_type(gmod::LuaBase* self, int iType) @cname("gmod__lua_base__new_user_type");
extern fn void push_user_type_value(gmod::LuaBase* self, void** val, int iType) @cname("gmod__lua_base__push_user_type_value");
extern fn LuaState* get_state(gmod::LuaBase* self) @cname("gmod__lua_base__get_state");
// extern fn void get_f_env(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_f_env");
// extern fn int set_f_env(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__set_f_env");
// extern fn char* push_formatted_string(gmod::LuaBase* self, char* fmt, va_list args) @cname("gmod__lua_base__push_formatted_string");
// extern fn char* push_formatted_string1(gmod::LuaBase* self, char* fmt) @cname("gmod__lua_base__push_formatted_string1");
// extern fn void error(gmod::LuaBase* self) @cname("gmod__lua_base__error");
// extern fn void formatted_error(gmod::LuaBase* self, char* fmt) @cname("gmod__lua_base__formatted_error");
// extern fn void type_error(gmod::LuaBase* self, int iStackPos, char* tname) @cname("gmod__lua_base__type_error");
// extern fn void* get_pointer(gmod::LuaBase* self, int iStackPos) @cname("gmod__lua_base__get_pointer");
// extern fn int call_meta(gmod::LuaBase* self, int iStackPos, char* e) @cname("gmod__lua_base__call_meta");
// extern fn int get_upvalue_index(gmod::LuaBase* self, int iPos) @cname("gmod__lua_base__get_upvalue_index");
// extern fn int get_stack(gmod::LuaBase* self, int level, lua_Debug* ar) @cname("gmod__lua_base__get_stack");
// extern fn int get_info(gmod::LuaBase* self, char* what, lua_Debug* ar) @cname("gmod__lua_base__get_info");