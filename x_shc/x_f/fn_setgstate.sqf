//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_setgstate.sqf"
#include "x_setup.sqf"

private ["_grp", "_gstate"];
_grp = [_this, 0] call BIS_fnc_param;
_gstate = [_this, 1] call BIS_fnc_param;
__TRACE_2("","_grp","_gstate")
_grp setVariable ["d_gstate", _gstate];
if (d_IS_HC_CLIENT) then {
	["d_setgrps", _grp] call d_fnc_NetCallEventCTS;
};