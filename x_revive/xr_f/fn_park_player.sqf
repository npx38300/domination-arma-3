//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_park_player.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private "_dosleep";
_dosleep = [_this, 0] call BIS_fnc_param;
__TRACE_1("park_player","_dosleep")
player setVariable ["xr_isdead", true];
xr_phd_invulnerable = true;
if (_dosleep) then {
	_etime = time + (player getVariable "xr_presptime") - 1.3;
	__TRACE_1("killedeh spawn","_etime")
	waitUntil {time >= _etime};
	__TRACE("park_player, black out")
	172 cutText [localize "STR_DOM_MISSIONSTRING_931", "BLACK OUT", 1];
	waitUntil {alive player};
};
player setPos (markerPos "xr_playerparkmarker");
["d_h_o_g", player] call d_fnc_NetCallEventCTS;
[false] spawn xr_fnc_spectating;
__TRACE("park_player, black in")
172 cutText [localize "STR_DOM_MISSIONSTRING_931", "BLACK IN", 1];