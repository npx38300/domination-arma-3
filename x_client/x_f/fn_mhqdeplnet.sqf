//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_mhqdeplnet.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_mhq", "_isdeployed", "_name", "_vside"];
_mhq = [_this, 0] call BIS_fnc_param;
_isdeployed = [_this, 1] call BIS_fnc_param;
_name = _mhq getVariable "d_vec_name";
__TRACE_3("","_mhq","_isdeployed","_name")
if (isNil "_name") exitWith {};
_m = _mhq getVariable "d_marker";
if (_isdeployed) then {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_647", _name];
	if (!isNil "_m") then {_m setMarkerTextLocal format [localize "STR_DOM_MISSIONSTRING_261", _mhq getVariable "d_ma_text"]};
} else {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_648", _name];
	if (!isNil "_m") then {_m setMarkerTextLocal (_mhq getVariable "d_ma_text")};
};