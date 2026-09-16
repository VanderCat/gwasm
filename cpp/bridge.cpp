#define GMOD_ALLOW_DEPRECATED
#include "garrysmod_common/include/GarrysMod/Lua/LuaInterface.h"
#include "garrysmod_common/include/GarrysMod/Lua/LuaGameCallback.h"
#include "garrysmod_common/include/GarrysMod/Lua/LuaObject.h"
// #include <string>
#define EXTERN extern "C"
// typedef void* iface;
using namespace GarrysMod::Lua;
using namespace Bootil;
#define BODY(body) body

EXTERN int gmod__lua_base__top(ILuaBase* self) BODY({
    return self->Top();
})
EXTERN void gmod__lua_base__push(ILuaBase* self, int iStackPos) BODY({
    return self->Push(iStackPos);
})
EXTERN void gmod__lua_base__pop(ILuaBase* self, int iAmt) BODY({
    return self->Pop(iAmt);
})
EXTERN void gmod__lua_base__get_table(ILuaBase* self, int iStackPos) BODY({
    return self->GetTable(iStackPos);
})
EXTERN void gmod__lua_base__get_field(ILuaBase* self, int iStackPos, const char* strName) BODY({
    return self->GetField(iStackPos, strName);
})
EXTERN void gmod__lua_base__set_field(ILuaBase* self, int iStackPos, const char* strName) BODY({
    return self->SetField(iStackPos, strName);
})
EXTERN void gmod__lua_base__create_table(ILuaBase* self) BODY({
    return self->CreateTable();
})
EXTERN void gmod__lua_base__set_table(ILuaBase* self, int iStackPos) BODY({
    return self->SetTable(iStackPos);
})
EXTERN void gmod__lua_base__set_meta_table(ILuaBase* self, int iStackPos) BODY({
    return self->SetMetaTable(iStackPos);
})
EXTERN bool gmod__lua_base__get_meta_table(ILuaBase* self, int i) BODY({
    return self->GetMetaTable(i);
})
EXTERN void gmod__lua_base__call(ILuaBase* self, int iArgs, int iResults) BODY({
    return self->Call(iArgs, iResults);
})
EXTERN int gmod__lua_base__p_call(ILuaBase* self, int iArgs, int iResults, int iErrorFunc) BODY({
    return self->PCall(iArgs, iResults, iErrorFunc);
})
EXTERN int gmod__lua_base__equal(ILuaBase* self, int iA, int iB) BODY({
    return self->Equal(iA, iB);
})
EXTERN int gmod__lua_base__raw_equal(ILuaBase* self, int iA, int iB) BODY({
    return self->RawEqual(iA, iB);
})
EXTERN void gmod__lua_base__insert(ILuaBase* self, int iStackPos) BODY({
    return self->Insert(iStackPos);
})
EXTERN void gmod__lua_base__remove(ILuaBase* self, int iStackPos) BODY({
    return self->Remove(iStackPos);
})
EXTERN int gmod__lua_base__next(ILuaBase* self, int iStackPos) BODY({
    return self->Next(iStackPos);
})
EXTERN void gmod__lua_base__throw_error(ILuaBase* self, const char* strError) BODY({
    return self->ThrowError(strError);
})
EXTERN void gmod__lua_base__check_type(ILuaBase* self, int iStackPos, int iType) BODY({
    return self->CheckType(iStackPos, iType);
})
EXTERN void gmod__lua_base__arg_error(ILuaBase* self, int iArgNum, const char* strMessage) BODY({
    return self->ArgError(iArgNum, strMessage);
})
EXTERN void gmod__lua_base__raw_get(ILuaBase* self, int iStackPos) BODY({
    return self->RawGet(iStackPos);
})
EXTERN void gmod__lua_base__raw_set(ILuaBase* self, int iStackPos) BODY({
    return self->RawSet(iStackPos);
})
EXTERN const char* gmod__lua_base__get_string(ILuaBase* self, int iStackPos, unsigned int* iOutLen) BODY({
    return self->GetString(iStackPos, iOutLen);
})
EXTERN double gmod__lua_base__get_number(ILuaBase* self, int iStackPos) BODY({
    return self->GetNumber(iStackPos);
})
EXTERN bool gmod__lua_base__get_bool(ILuaBase* self, int iStackPos) BODY({
    return self->GetBool(iStackPos);
})
EXTERN CFunc gmod__lua_base__get_c_function(ILuaBase* self, int iStackPos) BODY({
    return self->GetCFunction(iStackPos);
})
EXTERN void gmod__lua_base__push_nil(ILuaBase* self) BODY({
    return self->PushNil();
})
EXTERN void gmod__lua_base__push_string(ILuaBase* self, const char* val, unsigned int iLen) BODY({
    return self->PushString(val, iLen);
})
EXTERN void gmod__lua_base__push_number(ILuaBase* self, double val) BODY({
    return self->PushNumber(val);
})
EXTERN void gmod__lua_base__push_bool(ILuaBase* self, bool val) BODY({
    return self->PushBool(val);
})
EXTERN void gmod__lua_base__push_c_function(ILuaBase* self, CFunc val) BODY({
    return self->PushCFunction(val);
})
EXTERN void gmod__lua_base__push_c_closure(ILuaBase* self, CFunc val, int iVars) BODY({
    return self->PushCClosure(val, iVars);
})
EXTERN int gmod__lua_base__reference_create(ILuaBase* self) BODY({
    return self->ReferenceCreate();
})
EXTERN void gmod__lua_base__reference_free(ILuaBase* self, int i) BODY({
    return self->ReferenceFree(i);
})
EXTERN void gmod__lua_base__reference_push(ILuaBase* self, int i) BODY({
    return self->ReferencePush(i);
})
EXTERN void gmod__lua_base__push_special(ILuaBase* self, int iType) BODY({
    return self->PushSpecial(iType);
})
EXTERN bool gmod__lua_base__is_type(ILuaBase* self, int iStackPos, int iType) BODY({
    return self->IsType(iStackPos, iType);
})
EXTERN int gmod__lua_base__get_type(ILuaBase* self, int iStackPos) BODY({
    return self->GetType(iStackPos);
})
EXTERN const char* gmod__lua_base__get_type_name(ILuaBase* self, int iType) BODY({
    return self->GetTypeName(iType);
})
EXTERN const char* gmod__lua_base__check_string(ILuaBase* self, int iStackPos) BODY({
    return self->CheckString(iStackPos);
})
EXTERN double gmod__lua_base__check_number(ILuaBase* self, int iStackPos) BODY({
    return self->CheckNumber(iStackPos);
})
EXTERN int gmod__lua_base__obj_len(ILuaBase* self, int iStackPos) BODY({
    return self->ObjLen(iStackPos);
})
EXTERN const QAngle* gmod__lua_base__get_angle(ILuaBase* self, int iStackPos) BODY({
    return &self->GetAngle(iStackPos);
})
EXTERN const Vector* gmod__lua_base__get_vector(ILuaBase* self, int iStackPos) BODY({
    return &self->GetVector(iStackPos);
})
EXTERN void gmod__lua_base__push_angle(ILuaBase* self, const QAngle* val) BODY({
    return self->PushAngle(*val);
})
EXTERN void gmod__lua_base__push_vector(ILuaBase* self, const Vector* val) BODY({
    return self->PushVector(*val);
})
EXTERN void gmod__lua_base__set_state(ILuaBase* self, lua_State* L) BODY({
    return self->SetState(L);
})
EXTERN int gmod__lua_base__create_meta_table(ILuaBase* self, const char* strName) BODY({
    return self->CreateMetaTable(strName);
})
EXTERN bool gmod__lua_base__push_meta_table(ILuaBase* self, int iType) BODY({
    return self->PushMetaTable(iType);
})
EXTERN void gmod__lua_base__push_user_type(ILuaBase* self, void* data, int iType) BODY({
    return self->PushUserType(data, iType);
})
EXTERN void gmod__lua_base__set_user_type(ILuaBase* self, int iStackPos, void* data) BODY({
    return self->SetUserType(iStackPos, data);
})
EXTERN void* gmod__lua_base__get_user_type(ILuaBase* self, int iStackPos, int iType) BODY({
    return self->GetUserType<void>(iStackPos, iType);
})
EXTERN void* gmod__lua_base__new_userdata(ILuaBase* self, unsigned int iSize) BODY({
    return self->NewUserdata(iSize);
})
//BORKED:
EXTERN void** gmod__lua_base__new_user_type(ILuaBase* self, int iType) BODY({
    return self->NewUserType<void*>(iType);
})
EXTERN void gmod__lua_base__push_user_type_value(ILuaBase* self, void**const val, int iType) BODY({
    return self->PushUserType_Value<void*>(*val, iType);
})
namespace _GetAPrivateFieldHack{
  struct Y {};
}

EXTERN lua_State* gmod__lua_base__get_state(ILuaBase* self) BODY({
    return self->GetState();
})
// EXTERN void gmod__lua_base__get_f_env(ILuaBase* self, int iStackPos) BODY({
//     return self->GetFEnv(iStackPos);
// })
// EXTERN int gmod__lua_base__set_f_env(ILuaBase* self, int iStackPos) BODY({
//     return self->SetFEnv(iStackPos);
// })
// EXTERN const char* gmod__lua_base__push_formatted_string(ILuaBase* self, const char* fmt, va_list args) BODY({
//     return self->PushFormattedString(fmt, args);
// })
// EXTERN const char* gmod__lua_base__push_formatted_string1(ILuaBase* self, const char* fmt) BODY({
//     return self->PushFormattedString(fmt);
// })
// EXTERN void gmod__lua_base__error(ILuaBase* self) BODY({
//     return self->Error();
// })
// EXTERN void gmod__lua_base__formatted_error(ILuaBase* self, const char* fmt) BODY({
//     return self->FormattedError(fmt);
// })
// EXTERN void gmod__lua_base__type_error(ILuaBase* self, int iStackPos, const char* tname) BODY({
//     return self->TypeError(iStackPos, tname);
// })
// EXTERN const void* gmod__lua_base__get_pointer(ILuaBase* self, int iStackPos) BODY({
//     return self->GetPointer(iStackPos);
// })
// EXTERN int gmod__lua_base__call_meta(ILuaBase* self, int iStackPos, const char* e) BODY({
//     return self->CallMeta(iStackPos, e);
// })
// EXTERN int gmod__lua_base__get_upvalue_index(ILuaBase* self, int iPos) BODY({
//     return self->GetUpvalueIndex(iPos);
// })
// EXTERN int gmod__lua_base__get_stack(ILuaBase* self, int level, lua_Debug* ar) BODY({
//     return self->GetStack(level, ar);
// })
// EXTERN int gmod__lua_base__get_info(ILuaBase* self, const char* what, lua_Debug* ar) BODY({
//     return self->GetInfo(what, ar);
// })
EXTERN bool gmod__lua_interface__init(ILuaInterface* self, ILuaGameCallback* param0, bool param1) BODY({
    return self->Init(param0, param1);
})
EXTERN void gmod__lua_interface__shutdown(ILuaInterface* self) BODY({
    return self->Shutdown();
})
EXTERN void gmod__lua_interface__cycle(ILuaInterface* self) BODY({
    return self->Cycle();
})
EXTERN ILuaObject* gmod__lua_interface__global(ILuaInterface* self) BODY({
    return self->Global();
})
EXTERN ILuaObject* gmod__lua_interface__get_object(ILuaInterface* self, int index) BODY({
    return self->GetObject(index);
})
EXTERN void gmod__lua_interface__push_lua_object(ILuaInterface* self, ILuaObject* obj) BODY({
    return self->PushLuaObject(obj);
})
EXTERN void gmod__lua_interface__push_lua_function(ILuaInterface* self, CFunc func) BODY({
    return self->PushLuaFunction(func);
})
// EXTERN void gmod__lua_interface__lua_error(ILuaInterface* self, const char* err, int index) BODY({
//     return self->LuaError(err, index);
// })
// EXTERN void gmod__lua_interface__type_error(ILuaInterface* self, const char* name, int index) BODY({
//     return self->TypeError(name, index);
// })
EXTERN void gmod__lua_interface__call_internal(ILuaInterface* self, int args, int rets) BODY({
    return self->CallInternal(args, rets);
})
EXTERN void gmod__lua_interface__call_internal_no_returns(ILuaInterface* self, int args) BODY({
    return self->CallInternalNoReturns(args);
})
EXTERN bool gmod__lua_interface__call_internal_get_bool(ILuaInterface* self, int args) BODY({
    return self->CallInternalGetBool(args);
})
EXTERN const char* gmod__lua_interface__call_internal_get_string(ILuaInterface* self, int args) BODY({
    return self->CallInternalGetString(args);
})
EXTERN bool gmod__lua_interface__call_internal_get(ILuaInterface* self, int args, ILuaObject* obj) BODY({
    return self->CallInternalGet(args, obj);
})
EXTERN void gmod__lua_interface__new_global_table(ILuaInterface* self, const char* name) BODY({
    return self->NewGlobalTable(name);
})
EXTERN ILuaObject* gmod__lua_interface__new_temporary_object(ILuaInterface* self) BODY({
    return self->NewTemporaryObject();
})
EXTERN bool gmod__lua_interface__is_user_data(ILuaInterface* self, int index) BODY({
    return self->isUserData(index);
})
EXTERN ILuaObject* gmod__lua_interface__get_meta_table_object_ex(ILuaInterface* self, const char* name, int type) BODY({
    return self->GetMetaTableObject(name, type);
})
EXTERN ILuaObject* gmod__lua_interface__get_meta_table_object(ILuaInterface* self, int index) BODY({
    return self->GetMetaTableObject(index);
})
EXTERN ILuaObject* gmod__lua_interface__get_return(ILuaInterface* self, int index) BODY({
    return self->GetReturn(index);
})
EXTERN bool gmod__lua_interface__is_server(ILuaInterface* self) BODY({
    return self->IsServer();
})
EXTERN bool gmod__lua_interface__is_client(ILuaInterface* self) BODY({
    return self->IsClient();
})
EXTERN bool gmod__lua_interface__is_menu(ILuaInterface* self) BODY({
    return self->IsMenu();
})
EXTERN void gmod__lua_interface__destroy_object(ILuaInterface* self, ILuaObject* obj) BODY({
    return self->DestroyObject(obj);
})
EXTERN ILuaObject* gmod__lua_interface__create_object(ILuaInterface* self) BODY({
    return self->CreateObject();
})
EXTERN void gmod__lua_interface__set_member(ILuaInterface* self, ILuaObject* table, ILuaObject* key, ILuaObject* value) BODY({
    return self->SetMember(table, key, value);
})
EXTERN ILuaObject* gmod__lua_interface__get_new_table(ILuaInterface* self) BODY({
    return self->GetNewTable();
})
EXTERN void gmod__lua_interface__set_member_i(ILuaInterface* self, ILuaObject* table, float key) BODY({
    return self->SetMember(table, key);
})
EXTERN void gmod__lua_interface__set_member_i_ex(ILuaInterface* self, ILuaObject* table, float key, ILuaObject* value) BODY({
    return self->SetMember(table, key, value);
})
EXTERN void gmod__lua_interface__set_member_k(ILuaInterface* self, ILuaObject* table, const char* key) BODY({
    return self->SetMember(table, key);
})
EXTERN void gmod__lua_interface__set_member_kex(ILuaInterface* self, ILuaObject* table, const char* key, ILuaObject* value) BODY({
    return self->SetMember(table, key, value);
})
EXTERN void gmod__lua_interface__set_type(ILuaInterface* self, unsigned char param0) BODY({
    return self->SetType(param0);
})
EXTERN void gmod__lua_interface__push_long(ILuaInterface* self, long num) BODY({
    return self->PushLong(num);
})
EXTERN int gmod__lua_interface__get_flags(ILuaInterface* self, int index) BODY({
    return self->GetFlags(index);
})
EXTERN bool gmod__lua_interface__find_on_objects_meta_table(ILuaInterface* self, int objIndex, int keyIndex) BODY({
    return self->FindOnObjectsMetaTable(objIndex, keyIndex);
})
EXTERN bool gmod__lua_interface__find_object_on_table(ILuaInterface* self, int tableIndex, int keyIndex) BODY({
    return self->FindObjectOnTable(tableIndex, keyIndex);
})
EXTERN void gmod__lua_interface__set_member_fast(ILuaInterface* self, ILuaObject* table, int keyIndex, int valueIndex) BODY({
    return self->SetMemberFast(table, keyIndex, valueIndex);
})
EXTERN bool gmod__lua_interface__run_string(ILuaInterface* self, const char* filename, const char* path, const char* stringToRun, bool run, bool showErrors) BODY({
    return self->RunString(filename, path, stringToRun, run, showErrors);
})
EXTERN bool gmod__lua_interface__is_equal(ILuaInterface* self, ILuaObject* objA, ILuaObject* objB) BODY({
    return self->IsEqual(objA, objB);
})
// EXTERN void gmod__lua_interface__error(ILuaInterface* self, const char* err) BODY({
//     return self->Error(err);
// })
// EXTERN const char* gmod__lua_interface__get_string_or_error(ILuaInterface* self, int index) BODY({
//     return self->GetStringOrError(index);
// })
EXTERN bool gmod__lua_interface__run_lua_module(ILuaInterface* self, const char* name) BODY({
    return self->RunLuaModule(name);
})
EXTERN bool gmod__lua_interface__find_and_run_script(ILuaInterface* self, const char* filename, bool run, bool showErrors, const char* stringToRun, bool noReturns) BODY({
    return self->FindAndRunScript(filename, run, showErrors, stringToRun, noReturns);
})
EXTERN void gmod__lua_interface__set_path_id(ILuaInterface* self, const char* pathID) BODY({
    return self->SetPathID(pathID);
})
EXTERN const char* gmod__lua_interface__get_path_id(ILuaInterface* self) BODY({
    return self->GetPathID();
})
// EXTERN void gmod__lua_interface__ErrorNoHalt(ILuaInterface* self, const char* fmt) BODY({
//     return self->ErrorNoHalt(fmt);
// })
EXTERN void gmod__lua_interface__msg(ILuaInterface* self, const char* str) BODY({
    return self->Msg("%s", str);
})
EXTERN void gmod__lua_interface__push_path(ILuaInterface* self, const char* path) BODY({
    return self->PushPath(path);
})
EXTERN void gmod__lua_interface__pop_path(ILuaInterface* self) BODY({
    return self->PopPath();
})
EXTERN const char* gmod__lua_interface__get_path(ILuaInterface* self) BODY({
    return self->GetPath();
})
EXTERN int gmod__lua_interface__get_color(ILuaInterface* self, int index) BODY({
    return self->GetColor(index);
})
// void* gmod__lua_interface__PushColor(ILuaInterface* self, Color color) BODY({
//     return self->PushColor(color);
// })
// int gmod__lua_interface__GetStack(ILuaInterface* self, int level, lua_Debug* dbg) BODY({
//     return self->GetStack(level, dbg);
// })
// int gmod__lua_interface__GetInfo(ILuaInterface* self, const char* what, lua_Debug* dbg) BODY({
//     return self->GetInfo(what, dbg);
// })
const char* gmod__lua_interface__get_local(ILuaInterface* self, lua_Debug* dbg, int n) BODY({
    return self->GetLocal(dbg, n);
})
EXTERN const char* gmod__lua_interface__get_upvalue(ILuaInterface* self, int funcIndex, int n) BODY({
    return self->GetUpvalue(funcIndex, n);
})
EXTERN bool gmod__lua_interface__run_string_ex(ILuaInterface* self, const char* filename, const char* path, const char* stringToRun, bool run, bool printErrors, bool dontPushErrors, bool noReturns) BODY({
    return self->RunStringEx(filename, path, stringToRun, run, printErrors, dontPushErrors, noReturns);
})
EXTERN size_t gmod__lua_interface__get_data_string(ILuaInterface* self, int index, const char** str) BODY({
    return self->GetDataString(index, str);
})
EXTERN void gmod__lua_interface__error_from_lua(ILuaInterface* self, const char* fmt) BODY({
    return self->ErrorFromLua(fmt);
})
EXTERN const char* gmod__lua_interface__get_current_location(ILuaInterface* self) BODY({
    return self->GetCurrentLocation();
})
EXTERN void gmod__lua_interface__msg_colour(ILuaInterface* self, const Color* col, const char* fmt) BODY({
    return self->MsgColour(*col, "%s", fmt);
})
// void gmod__lua_interface__GetCurrentFile(ILuaInterface* self, char** outStr) BODY({
//     std::string meow = "";
//     return self->GetCurrentFile(meow);
//     outStr = &meow.c_str();
// })
//BORKED:
// EXTERN bool gmod__lua_interface__CompileString(ILuaInterface* self, Buffer* dumper, const char* stringToCompile) BODY({
//     return self->CompileString(*dumper, stringToCompile);
// })

EXTERN bool gmod__lua_interface__call_function_protected(ILuaInterface* self, int param0, int param1, bool param2) BODY({
    return self->CallFunctionProtected(param0, param1, param2);
})
EXTERN void gmod__lua_interface__require(ILuaInterface* self, const char* name) BODY({
    return self->Require(name);
})
EXTERN const char* gmod__lua_interface__get_actual_type_name(ILuaInterface* self, int type) BODY({
    return self->GetActualTypeName(type);
})
EXTERN void gmod__lua_interface__pre_create_table(ILuaInterface* self, int arrelems, int nonarrelems) BODY({
    return self->PreCreateTable(arrelems, nonarrelems);
})
EXTERN void gmod__lua_interface__push_pooled_string(ILuaInterface* self, int index) BODY({
    return self->PushPooledString(index);
})
EXTERN const char* gmod__lua_interface__get_pooled_string(ILuaInterface* self, int index) BODY({
    return self->GetPooledString(index);
})
EXTERN int gmod__lua_interface__add_threaded_call(ILuaInterface* self, ILuaThreadedCall* call) BODY({
    return self->AddThreadedCall(call);
})
EXTERN void gmod__lua_interface__append_stack_trace(ILuaInterface* self, char* param0, unsigned int param1) BODY({
    return self->AppendStackTrace(param0, param1);
})
EXTERN ConVar* gmod__lua_interface__create_con_var(ILuaInterface* self, const char* name, const char* defaultValue, const char* helpString, int flags) BODY({
    return self->CreateConVar(name, defaultValue, helpString, flags);
})
EXTERN ConCommand* gmod__lua_interface__create_con_command(ILuaInterface* self, const char* name, const char* helpString, int flags, 
    #ifdef __cplusplus
    void ( *callback )( const CCommand & ), 
    #else
    void ( *callback )( const CCommand* ),
    #endif
    int ( *completionFunc )( const char *, char ( * )[128] )) BODY({
    return self->CreateConCommand(name, helpString, flags, callback, completionFunc);
})
EXTERN const char* gmod__lua_interface__check_string_opt(ILuaInterface* self, int iStackPos, const char* def) BODY({
    return self->CheckStringOpt(iStackPos, def);
})
EXTERN double gmod__lua_interface__check_number_opt(ILuaInterface* self, int iStackPos, double def) BODY({
    return self->CheckNumberOpt(iStackPos, def);
})
EXTERN int gmod__lua_interface__register_meta_table(ILuaInterface* self, const char* name, ILuaObject* tbl) BODY({
    return self->RegisterMetaTable(name, tbl);
})

EXTERN ILuaObject* gmod__lua_game_callback__create_lua_object(ILuaGameCallback* self) BODY({
    return self->CreateLuaObject();
})
EXTERN void gmod__lua_game_callback__destroy_lua_object(ILuaGameCallback* self, ILuaObject* pObject) BODY({
    return self->DestroyLuaObject(pObject);
})
EXTERN void gmod__lua_game_callback__error_print(ILuaGameCallback* self, const char* error, bool print) BODY({
    return self->ErrorPrint(error, print);
})
EXTERN void gmod__lua_game_callback__msg(ILuaGameCallback* self, const char* msg, bool useless) BODY({
    return self->Msg(msg, useless);
})
EXTERN void gmod__lua_game_callback__msg_colour(ILuaGameCallback* self, const char* msg, const Color* color) BODY({
    return self->MsgColour(msg, *color);
})
EXTERN void gmod__lua_game_callback__lua_error(ILuaGameCallback* self, const ILuaGameCallback::CLuaError* error) BODY({
    return self->LuaError(error);
})
EXTERN void gmod__lua_game_callback__interface_created(ILuaGameCallback* self, ILuaInterface* iface) BODY({
    return self->InterfaceCreated(iface);
})

EXTERN void gmod__lua_object__set(ILuaObject* self, ILuaObject* obj) BODY({
    return self->Set(obj);
})
EXTERN void gmod__lua_object__set_from_stack(ILuaObject* self, int i) BODY({
    return self->SetFromStack(i);
})
EXTERN void gmod__lua_object__un_reference(ILuaObject* self) BODY({
    return self->UnReference();
})
EXTERN int gmod__lua_object__get_type(ILuaObject* self) BODY({
    return self->GetType();
})
EXTERN const char* gmod__lua_object__get_string(ILuaObject* self) BODY({
    return self->GetString();
})
EXTERN float gmod__lua_object__get_float(ILuaObject* self) BODY({
    return self->GetFloat();
})
EXTERN int gmod__lua_object__get_int(ILuaObject* self) BODY({
    return self->GetInt();
})
EXTERN void* gmod__lua_object__get_user_data(ILuaObject* self) BODY({
    return self->GetUserData();
})
EXTERN void gmod__lua_object__set_member(ILuaObject* self, const char* name) BODY({
    return self->SetMember(name);
})
EXTERN void gmod__lua_object__set_member1(ILuaObject* self, const char* name, ILuaObject* obj) BODY({
    return self->SetMember(name, obj);
})
EXTERN void gmod__lua_object__set_member2(ILuaObject* self, const char* name, float val) BODY({
    return self->SetMember(name, val);
})
EXTERN void gmod__lua_object__set_member3(ILuaObject* self, const char* name, bool val) BODY({
    return self->SetMember(name, val);
})
EXTERN void gmod__lua_object__set_member4(ILuaObject* self, const char* name, const char* val) BODY({
    return self->SetMember(name, val);
})
EXTERN void gmod__lua_object__set_member5(ILuaObject* self, const char* name, CFunc f) BODY({
    return self->SetMember(name, f);
})
EXTERN bool gmod__lua_object__get_member_bool(ILuaObject* self, const char* name, bool b) BODY({
    return self->GetMemberBool(name, b);
})
EXTERN int gmod__lua_object__get_member_int(ILuaObject* self, const char* name, int i) BODY({
    return self->GetMemberInt(name, i);
})
EXTERN float gmod__lua_object__get_member_float(ILuaObject* self, const char* name, float f) BODY({
    return self->GetMemberFloat(name, f);
})
EXTERN const char* gmod__lua_object__get_member_str(ILuaObject* self, const char* name, const char* s) BODY({
    return self->GetMemberStr(name, s);
})
EXTERN void* gmod__lua_object__get_member_user_data(ILuaObject* self, const char* name, void* u) BODY({
    return self->GetMemberUserData(name, u);
})
EXTERN void* gmod__lua_object__get_member_user_data1(ILuaObject* self, float name, void* u) BODY({
    return self->GetMemberUserData(name, u);
})
EXTERN ILuaObject* gmod__lua_object__get_member(ILuaObject* self, const char* name, ILuaObject* obj) BODY({
    return self->GetMember(name, obj);
})
EXTERN ILuaObject* gmod__lua_object__get_member1(ILuaObject* self, ILuaObject* key, ILuaObject* obj) BODY({
    return self->GetMember(key, obj);
})
EXTERN void gmod__lua_object__set_meta_table(ILuaObject* self, ILuaObject* obj) BODY({
    return self->SetMetaTable(obj);
})
EXTERN void gmod__lua_object__set_user_data(ILuaObject* self, void* obj) BODY({
    return self->SetUserData(obj);
})
EXTERN void gmod__lua_object__push(ILuaObject* self) BODY({
    return self->Push();
})
EXTERN bool gmod__lua_object__is_nil(ILuaObject* self) BODY({
    return self->isNil();
})
EXTERN bool gmod__lua_object__is_table(ILuaObject* self) BODY({
    return self->isTable();
})
EXTERN bool gmod__lua_object__is_string(ILuaObject* self) BODY({
    return self->isString();
})
EXTERN bool gmod__lua_object__is_number(ILuaObject* self) BODY({
    return self->isNumber();
})
EXTERN bool gmod__lua_object__is_function(ILuaObject* self) BODY({
    return self->isFunction();
})
EXTERN bool gmod__lua_object__is_user_data(ILuaObject* self) BODY({
    return self->isUserData();
})
EXTERN ILuaObject* gmod__lua_object__get_member2(ILuaObject* self, float fKey, ILuaObject* obj) BODY({
    return self->GetMember(fKey, obj);
})
EXTERN void* gmod__lua_object__remove_me_1(ILuaObject* self, const char* name, void* param0) BODY({
    return self->Remove_Me_1(name, param0);
})
EXTERN void gmod__lua_object__set_member6(ILuaObject* self, float fKey) BODY({
    return self->SetMember(fKey);
})
EXTERN void gmod__lua_object__set_member7(ILuaObject* self, float fKey, ILuaObject* obj) BODY({
    return self->SetMember(fKey, obj);
})
EXTERN void gmod__lua_object__set_member8(ILuaObject* self, float fKey, float val) BODY({
    return self->SetMember(fKey, val);
})
EXTERN void gmod__lua_object__set_member9(ILuaObject* self, float fKey, bool val) BODY({
    return self->SetMember(fKey, val);
})
EXTERN void gmod__lua_object__set_member10(ILuaObject* self, float fKey, const char* val) BODY({
    return self->SetMember(fKey, val);
})
EXTERN void gmod__lua_object__set_member11(ILuaObject* self, float fKey, CFunc f) BODY({
    return self->SetMember(fKey, f);
})
EXTERN const char* gmod__lua_object__get_member_str1(ILuaObject* self, float name, const char* s) BODY({
    return self->GetMemberStr(name, s);
})
EXTERN void gmod__lua_object__set_member12(ILuaObject* self, ILuaObject* k, ILuaObject* v) BODY({
    return self->SetMember(k, v);
})
EXTERN bool gmod__lua_object__get_bool(ILuaObject* self) BODY({
    return self->GetBool();
})
EXTERN bool gmod__lua_object__push_member_fast(ILuaObject* self, int iStackPos) BODY({
    return self->PushMemberFast(iStackPos);
})
EXTERN void gmod__lua_object__set_member_fast(ILuaObject* self, int iKey, int iValue) BODY({
    return self->SetMemberFast(iKey, iValue);
})
EXTERN void gmod__lua_object__set_float(ILuaObject* self, float val) BODY({
    return self->SetFloat(val);
})
EXTERN void gmod__lua_object__set_string(ILuaObject* self, const char* val) BODY({
    return self->SetString(val);
})
EXTERN double gmod__lua_object__get_double(ILuaObject* self) BODY({
    return self->GetDouble();
})
EXTERN void gmod__lua_object__set_member_fix_key(ILuaObject* self, const char* param0, float param1) BODY({
    return self->SetMember_FixKey(param0, param1);
})
EXTERN void gmod__lua_object__set_member_fix_key1(ILuaObject* self, const char* param0, const char* param1) BODY({
    return self->SetMember_FixKey(param0, param1);
})
EXTERN void gmod__lua_object__set_member_fix_key2(ILuaObject* self, const char* param0, ILuaObject* param1) BODY({
    return self->SetMember_FixKey(param0, param1);
})
EXTERN void gmod__lua_object__set_member_fix_key3(ILuaObject* self, const char* param0, double param1) BODY({
    return self->SetMember_FixKey(param0, param1);
})
EXTERN void gmod__lua_object__set_member_fix_key4(ILuaObject* self, const char* param0, int param1) BODY({
    return self->SetMember_FixKey(param0, param1);
})
EXTERN bool gmod__lua_object__is_bool(ILuaObject* self) BODY({
    return self->isBool();
})
EXTERN void gmod__lua_object__set_member_double(ILuaObject* self, const char* param0, double param1) BODY({
    return self->SetMemberDouble(param0, param1);
})
EXTERN void gmod__lua_object__set_member_nil(ILuaObject* self, const char* param0) BODY({
    return self->SetMemberNil(param0);
})
EXTERN void gmod__lua_object__set_member_nil1(ILuaObject* self, float param0) BODY({
    return self->SetMemberNil(param0);
})
EXTERN bool gmod__lua_object__remove_me(ILuaObject* self) BODY({
    return self->RemoveMe();
})
EXTERN void gmod__lua_object__init(ILuaObject* self) BODY({
    return self->Init();
})
EXTERN void gmod__lua_object__set_from_global(ILuaObject* self, const char* param0) BODY({
    return self->SetFromGlobal(param0);
})
EXTERN int gmod__lua_object__get_string_len(ILuaObject* self, unsigned int* param0) BODY({
    return self->GetStringLen(param0);
})
EXTERN unsigned int gmod__lua_object__get_member_u_int(ILuaObject* self, const char* param0, unsigned int param1) BODY({
    return self->GetMemberUInt(param0, param1);
})
EXTERN void gmod__lua_object__set_member13(ILuaObject* self, const char* param0, unsigned long long param1) BODY({
    return self->SetMember(param0, param1);
})
EXTERN void gmod__lua_object__set_member14(ILuaObject* self, const char* param0, int param1) BODY({
    return self->SetMember(param0, param1);
})
EXTERN void gmod__lua_object__set_reference(ILuaObject* self, int param0) BODY({
    return self->SetReference(param0);
})
EXTERN void gmod__lua_object__remove_member(ILuaObject* self, const char* param0) BODY({
    return self->RemoveMember(param0);
})
EXTERN void gmod__lua_object__remove_member15(ILuaObject* self, float param0) BODY({
    return self->RemoveMember(param0);
})
EXTERN bool gmod__lua_object__member_is_nil(ILuaObject* self, const char* param0) BODY({
    return self->MemberIsNil(param0);
})
EXTERN void gmod__lua_object__set_member_double1(ILuaObject* self, float param0, double param1) BODY({
    return self->SetMemberDouble(param0, param1);
})
EXTERN double gmod__lua_object__get_member_double(ILuaObject* self, const char* param0, double param1) BODY({
    return self->GetMemberDouble(param0, param1);
})
EXTERN BaseEntity* gmod__lua_object__get_member_entity(ILuaObject* self, const char* param0, BaseEntity* param1) BODY({
    return self->GetMemberEntity(param0, param1);
})
EXTERN void gmod__lua_object__set_member_entity(ILuaObject* self, float param0, BaseEntity* param1) BODY({
    return self->SetMemberEntity(param0, param1);
})
EXTERN void gmod__lua_object__set_member_entity1(ILuaObject* self, const char* param0, BaseEntity* param1) BODY({
    return self->SetMemberEntity(param0, param1);
})
EXTERN bool gmod__lua_object__is_entity(ILuaObject* self) BODY({
    return self->isEntity();
})
EXTERN BaseEntity* gmod__lua_object__get_entity(ILuaObject* self) BODY({
    return self->GetEntity();
})
EXTERN void gmod__lua_object__set_entity(ILuaObject* self, BaseEntity* param0) BODY({
    return self->SetEntity(param0);
})
EXTERN void gmod__lua_object__set_member_vector(ILuaObject* self, const char* param0, Vector* param1) BODY({
    return self->SetMemberVector(param0, param1);
})
EXTERN void gmod__lua_object__set_member_vector1(ILuaObject* self, const char* param0, Vector* param1) BODY({
    return self->SetMemberVector(param0, param1);
})
EXTERN void gmod__lua_object__set_member_vector2(ILuaObject* self, float param0, Vector* param1) BODY({
    return self->SetMemberVector(param0, param1);
})
EXTERN Vector* gmod__lua_object__GetMemberVector(ILuaObject* self, const char* param0, const Vector* param1) BODY({
    return self->GetMemberVector(param0, param1);
})
EXTERN Vector* gmod__lua_object__get_member_vector1(ILuaObject* self, int param0) BODY({
    return self->GetMemberVector(param0);
})
EXTERN Vector* gmod__lua_object__get_vector(ILuaObject* self) BODY({
    return self->GetVector();
})
EXTERN bool gmod__lua_object__is_vector(ILuaObject* self) BODY({
    return self->isVector();
})
EXTERN void gmod__lua_object__set_member_angle(ILuaObject* self, const char* param0, QAngle* param1) BODY({
    return self->SetMemberAngle(param0, param1);
})
EXTERN void gmod__lua_object__set_member_angle1(ILuaObject* self, const char* param0, QAngle* param1) BODY({
    return self->SetMemberAngle(param0, param1);
})
EXTERN QAngle* gmod__lua_object__get_member_angle(ILuaObject* self, const char* param0, QAngle* param1) BODY({
    return self->GetMemberAngle(param0, param1);
})
EXTERN QAngle* gmod__lua_object__get_angle(ILuaObject* self) BODY({
    return self->GetAngle();
})
EXTERN bool gmod__lua_object__is_angle(ILuaObject* self) BODY({
    return self->isAngle();
})
EXTERN void gmod__lua_object__set_member_matrix(ILuaObject* self, const char* param0, const VMatrix* param1) BODY({
    return self->SetMemberMatrix(param0, param1);
})
EXTERN void gmod__lua_object__set_member_matrix1(ILuaObject* self, const char* param0, const VMatrix* param1) BODY({
    return self->SetMemberMatrix(param0, param1);
})
EXTERN void gmod__lua_object__set_member_matrix2(ILuaObject* self, float param0, const VMatrix* param1) BODY({
    return self->SetMemberMatrix(param0, param1);
})
EXTERN void gmod__lua_object__set_member_matrix3(ILuaObject* self, int param0, const VMatrix* param1) BODY({
    return self->SetMemberMatrix(param0, param1);
})
EXTERN void gmod__lua_object__set_member_phys_object(ILuaObject* self, const char* param0, IPhysicsObject* param1) BODY({
    return self->SetMemberPhysObject(param0, param1);
})
EXTERN double gmod__lua_object__get_member_double1(ILuaObject* self, float param0, double param1) BODY({
    return self->GetMemberDouble(param0, param1);
})
// EXTERN ILuaBase* c_lua_object_get_lua(CLuaObject* self) BODY({
//     return self->GetLua();
// })
// EXTERN void c_lua_object_set_lua(CLuaObject* self, ILuaBase* Lua) BODY({
//     return self->SetLua(Lua);
// })
// EXTERN int c_lua_object_get_reference(CLuaObject* self) BODY({
//     return self->GetReference();
// })
// EXTERN int c_lua_object_get_internal_type(CLuaObject* self) BODY({
//     return self->GetInternalType();
// })