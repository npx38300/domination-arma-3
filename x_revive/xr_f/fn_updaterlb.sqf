//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_updaterlb.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_display"];

d_beam_target = "";
//d_tele_dialog = 0; // 0 = respawn, 1 = teleport

d_x_loop_end = false;

0 spawn {
	scriptName "spawn_updaterlb";
	sleep 0.1;
	while {!d_x_loop_end} do {
		if (!d_x_loop_end) then {[1] call d_fnc_teleupdate_dlg};
		sleep 1.012;
	};
};
