// by Xeno
#define __DEBUG__
#define THIS_FILE "x_revive\xr_f\fn_dorevive.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

__TRACE("start")
private ["_ma", "_endtime"];
player setVariable ["xr_pisinaction", true];
player setVariable ["xr_stop_revive", false];
_ma = "ainvpknlmstpslaywrfldnon_medic";
player playMove _ma;
_endtime = time + 12;
_cancelrevaction = player addAction ["<t color='#FF0000'>Cancel Revive</t>", {player setVariable ["xr_stop_revive", true]}, [], -1];
waitUntil {animationState player == _ma || {!alive player} || {time > _endtime}};
waitUntil {animationState player != _ma || {!alive player} || {player getVariable "xr_stop_revive"} || {time > _endtime}};
player removeAction _cancelrevaction;
player setVariable ["xr_pisinaction", false];
if (player getVariable "xr_stop_revive") exitWith {
	["d_eswm", player] call d_fnc_NetCallEvent;
};
if (time > _endtime) exitWith {};
if (alive player && {alive (player getVariable "xr_cursorTarget")}) then {
	if (xr_pl_can_revive) then {
		if (xr_help_bonus > 0 && {xr_max_lives != -1}) then {
			if (!d_with_ranked) then {
				hintSilent format [localize "STR_DOM_MISSIONSTRING_915", xr_help_bonus];
			} else {
				hintSilent format [localize "STR_DOM_MISSIONSTRING_916", xr_help_bonus, d_ranked_a select 21];
				["d_pas", [player, d_ranked_a select 21]] call d_fnc_NetCallEventCTS;
			};
			_lives = (player getVariable "xr_lives") + xr_help_bonus;
			__TRACE_1("","_lives")
			player setVariable ["xr_lives", _lives];
			["d_crl", [getPlayerUID player, _lives]] call d_fnc_NetCallEventCTS;
		};
		 (player getVariable "xr_cursorTarget") setVariable ["xr_pluncon", false, true];
		if (xr_revivemsg) then {
			["xr_msg", [xr_name_player, name (player getVariable "xr_cursorTarget"), side (group player)]] call d_fnc_NetCallEventToClients;
			systemChat format [localize "STR_DOM_MISSIONSTRING_914a", name (player getVariable "xr_cursorTarget")];
		};
	} else {
		["xr_cpr", [player getVariable "xr_cursorTarget"]] call d_fnc_NetCallEventSTO;
	};
};
__TRACE("end")