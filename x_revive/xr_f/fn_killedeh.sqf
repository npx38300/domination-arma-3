//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_killedeh.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

__TRACE_1("start","_this")
player setVariable ["xr_presptime", 6];
setPlayerRespawnTime 6;
__TRACE("respawn time 6")
player setVariable ["xr_death_pos", []];
_do_black = true;
if (player getVariable "xr_pluncon") then {
	call xr_fnc_CheckRespawn;
} else {
	player setVariable ["xr_pluncon", true, true];
	if (d_sub_kill_points != 0) then {
		["xr_add_sub_kill", player] call d_fnc_NetCallEventCTS;
	};
	private "_pdx";
	_pdx = (player getVariable "xr_num_death") + 1;
	__TRACE_1("","_pdx")
	player setVariable ["xr_num_death", _pdx];
	
	if (xr_max_lives != -1) then {
		private "_lives";
		_lives = (player getVariable "xr_lives") - 1;
		__TRACE_1("lives left","_lives")
		player setVariable ["xr_lives", _lives];
		["d_crl", [getPlayerUID player, _lives]] call d_fnc_NetCallEventCTS;
		if (_lives == -1) then {
			__TRACE("lives = -1")
			player setVariable ["xr_isdead", true];
			xr_phd_invulnerable = true;
			[true] spawn xr_fnc_park_player;
			player removeAllEventHandlers "killed";
			player removeAllEventHandlers "respawn";
			_do_black = false;
		};
	};
};
__TRACE_1("","_do_black")
if (_do_black) then {
	0 spawn {
		_etime = time + (player getVariable "xr_presptime") - 1.3;
		__TRACE_1("spawn","_etime")
		waitUntil {time >= _etime};
		__TRACE("spawn blacking out 1 sec before respawn")
		172 cutText ["","BLACK OUT", 1];
	};
};