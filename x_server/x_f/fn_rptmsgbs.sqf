//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_rptmsgbs.sqf"
#include "x_setup.sqf"

private ["_pl", "_pl_name", "_reason"];
_pl = [_this, 0] call BIS_fnc_param;
_pl_name = [_this, 1] call BIS_fnc_param;
_reason = [_this, 2] call BIS_fnc_param;
__TRACE_3("","_pl","_pl_name","_reason")
switch (_reason) do {
	case 0: {
		diag_log format [localize "STR_DOM_MISSIONSTRING_947", _pl_name, getPlayerUID _pl];
	};
	case 1: {
		diag_log format [localize "STR_DOM_MISSIONSTRING_948", _pl_name, getPlayerUID _pl];
	};
};