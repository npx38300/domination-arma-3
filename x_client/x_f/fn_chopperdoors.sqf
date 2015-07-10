//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_chopperdoors.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_heli","_state"];
_heli = [_this, 0] call BIS_fnc_param;
_state = (_this select 3) select 0;
{
	_heli animateDoor [_x, _state];
} forEach ((_this select 3) select 1);
