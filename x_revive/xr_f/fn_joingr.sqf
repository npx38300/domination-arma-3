//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_joingr.sqf"
#include "xr_macros.sqf"

__TRACE("joingr")
if (player getVariable "xr_isleader") then {
	["d_grpl", [xr_pl_group, player]] call d_fnc_NetCallEventSTO;
};
player setVariable ["xr_isleader", false];