//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_revive\xr_f\fn_addmarker.sqf"
#include "xr_macros.sqf"

if (!isServer) exitWith {};

private ["_mname", "_unit"];
_unit = [_this, 0] call BIS_fnc_param;
if (!alive _unit) exitWith {};
_mname = (str _unit) + "_xr_dead";
if (markerType _mname == "") then {
	[_mname, _this select 1, "ICON", "ColorBlue", [0.4,0.4], format [localize "STR_DOM_MISSIONSTRING_910", name _unit], 0, "mil_marker"] call d_fnc_CreateMarkerGlobal;
};
