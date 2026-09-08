module gmod;

extern fn gmod::LuaObject* LuaGameCallback.create_lua_object(gmod::LuaGameCallback* self);
extern fn void LuaGameCallback.destroy_lua_object(gmod::LuaGameCallback* self, gmod::LuaObject* pObject) @cname("gmod__lua_game_callback__destroy_lua_object");
extern fn void LuaGameCallback.error_print(gmod::LuaGameCallback* self, char* error, bool print) @cname("gmod__lua_game_callback__error_print");
extern fn void LuaGameCallback.msg(gmod::LuaGameCallback* self, char* msg, bool useless) @cname("gmod__lua_game_callback__msg");
extern fn void LuaGameCallback.msg_colour(gmod::LuaGameCallback* self, char* msg, Color* color) @cname("gmod__lua_game_callback__msg_colour");
// extern fn void LuaGameCallback.lua_error(gmod::LuaGameCallback* self, gmod::LuaGameCallback::CLuaError* error) @cname("gmod__lua_game_callback__lua_error");
extern fn void LuaGameCallback.interface_created(gmod::LuaGameCallback* self, gmod::LuaInterface* iface) @cname("gmod__lua_game_callback__interface_created");