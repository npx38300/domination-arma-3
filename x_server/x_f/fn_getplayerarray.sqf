//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getplayerarray.sqf"
#include "x_setup.sqf"

private ["_uid","_pa"];
_uid = [_this, 0] call BIS_fnc_param;
_pa = d_player_store getVariable _uid;
if (!isNil "_pa") then {
	_pa set [4, [_this, 1] call BIS_fnc_param];
	__TRACE_2("","_uid","_pa")
};