//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_prespawned.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

player setVariable ["d_isinaction", false];

if (d_WithMHQTeleport == 0 && {!isNil "d_fnc_dlgopenx"} && {d_WithRevive == 1}) then {
	call d_fnc_dlgopenx;
};
[1, _this] call d_fnc_playerspawn;