// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_player_stuff.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

__TRACE_1("","_this")
d_player_autokick_time = _this select 0;

if (d_WithRevive == 0 && {(_this select 8) == -1} && {xr_max_lives != -1}) then {
	0 spawn {
		scriptName "spawn_playerstuffparking";
		waitUntil {!d_still_in_intro};
		__TRACE("player_stuff, calling park_player")
		[false] spawn xr_fnc_park_player;
	};
};
