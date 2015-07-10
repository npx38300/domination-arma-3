#define THIS_FILE "fn_paraj.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_do_exit","_realpos", "_jumpobj", "_add_pchute_bp"];

_jumpobj = [_this, 0] call BIS_fnc_param;

if (player distance _jumpobj > 15) exitWith {};

_do_exit = false;
if (d_with_ranked) then {
	if (score player < (d_ranked_a select 4)) then {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_64", score player, d_ranked_a select 4];
		_do_exit = true;
	} else {
		["d_pas", [player, (d_ranked_a select 4) * -1]] call d_fnc_NetCallEventCTS;
	};
};

if (_do_exit) exitWith {};

if (isNil "d_next_jump_time") then {d_next_jump_time = -1};

if (d_HALOWaitTime > 0 && {player distance d_FLAG_BASE < 15} && {d_next_jump_time > time}) exitWith {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_65", round ((d_next_jump_time - time)/60)];
};

/*
_bpbp = backpack player;
_add_pchute_bp = false;
if (_bpbp == "") then {
	_add_pchute_bp = true;
} else {
	if (_bpbp != "" && {_bpbp != "B_Parachute"}) then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_66");
		_do_exit = true;
	};
};
if (_do_exit) exitWith {};
*/

d_global_jump_pos = [];
createDialog "d_ParajumpDialog";

waitUntil {!d_parajump_dialog_open || {!alive player} || {player getVariable ["xr_pluncon", false]}};
if (alive player && {!(player getVariable ["xr_pluncon", false])}) then {
	if !(d_global_jump_pos isEqualTo []) then {
	/*
		if (_add_pchute_bp) then {
			player addBackpack "B_Parachute";
		};
	*/
		_realpos = [d_global_jump_pos, 200, d_HALOJumpHeight] call d_fnc_GetRanJumpPoint;
		[_realpos] spawn d_fnc_pjump;
	};
} else {
	if (d_parajump_dialog_open) then {closeDialog 0};
};
