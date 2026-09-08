module gmod;
import std::core::env;
//const int LUA_PADDING = 70 @feat(X86);
const int LUA_PADDING = 114; //@feat(X86_64);

struct LuaState { 
	char[LUA_PADDING] _unknown;
	LuaBase* luabase;
}

typedef LuaInterface = void;
typedef LuaObject = void;
typedef LuaGameCallback = void;
typedef LuaThreadedCall = void;

alias LuaBase = LuaInterface;
alias CFunc = fn CInt(LuaState* l);
struct QAngle {
	float x;
	float y;
	float z;
}
struct Vector {
	float x;
	float y;
	float z;
}
typedef LuaDebug = void;
typedef VMatrix = void;
typedef Color = void;
typedef StdString = void;
typedef BootilBuffer = void;
typedef BaseEntity = void;
typedef ConVar = void;
typedef CCommand = void;
typedef ConCommand = void;
typedef IPhysicsObject = void;

constdef Index {
    GLOBAL = -10002,
    ENVIRONMENT,
    REGISTRY
}
enum Special {
	GLOBAL,       // Global table
	ENVIRONMENT,        // Environment table
	REGISTRY,        // Registry table
}

constdef Types {
    NONE = -1,
    NIL,
    BOOL,
    LIGHT_USER_DATA,
    NUMBER,
    STRING,
    TABLE,
    FUNCTION,
    USER_DATA,
    THREAD,

    // GMod Types
    ENTITY,
    VECTOR,
    ANGLE,
    PHYS_OBJ,
    SAVE,
    RESTORE,
    DAMAGE_INFO,
    EFFECT_DATA,
    MOVE_DATA,
    RECIPIENT_FILTER,
    USER_CMD,
    SCRIPTED_VEHICLE,
    MATERIAL,
    PANEL,
    PARTICLE,
    PARTICLE_EMITTER,
    TEXTURE,
    USER_MSG,
    CONVAR,
    IMESH,
    MATRIX,
    SOUND,
    PIXEL_VIS_HANDLE,
    DLIGHT,
    VIDEO,
    FILE,
    LOCOMOTION,
    PATH,
    NAV_AREA,
    SOUND_HANDLE,
    NAV_LADDER,
    PARTICLE_SYSTEM,
    PROJECTED_TEXTURE,
    PHYS_COLLIDE,
    SURFACE_INFO,
}

struct UserData {
	void* data;
	char type; // Change me to a uint32 one day
}