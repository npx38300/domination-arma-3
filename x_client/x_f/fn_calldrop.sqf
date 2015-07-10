// by Xeno
#define THIS_FILE "fn_calldrop.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {
	d_commandingMenuIniting = false;
};
private ["_oldpos"];

if (!alive player || {vehicle player == player && {(getPosATLVisual player) select 2 > 10}}) exitWith {
	d_commandingMenuIniting = false;
};
if !(d_para_available) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_163");
	d_commandingMenuIniting = false;
};

if (d_with_ranked && {score player < (d_ranked_a select 16)}) exitWith {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_164", score player, d_ranked_a select 16];
	d_commandingMenuIniting = false;
};

if ((d_with_ai || {d_with_ai_features == 0}) && {d_drop_blocked}) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_165");
	d_commandingMenuIniting = false;
};

if (d_with_ai|| {d_with_ai_features == 0}) then {
	d_drop_blocked = true; publicVariable "d_drop_blocked";
};

["arti1_marker_1",getPosASL player,"ELLIPSE","ColorYellow",[d_drop_max_dist, d_drop_max_dist],"",0,"","FDiagonal"] call d_fnc_CreateMarkerLocal;

d_x_drop_type = "";
_oldpos = markerPos "d_drop_zone";

createDialog "d_AirDropDialog";
d_commandingMenuIniting = false;

waitUntil {d_x_drop_type != "" || {!d_airdrop_dialog_open} || {!alive player} || {player getVariable ["xr_pluncon", false]}};

deleteMarkerLocal "arti1_marker_1";
if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {
	if (d_airdrop_dialog_open) then {closeDialog 0};
	"d_drop_zone" setMarkerPos _oldpos;
	if (d_with_ai|| {d_with_ai_features == 0}) then {
		d_drop_blocked = false; publicVariable "d_drop_blocked";
	};
};
if (d_x_drop_type != "") then {
	_ppl = getPosASL player;
	_ppl set [2,0];
	if (_ppl distance (markerPos "d_drop_zone") > d_drop_max_dist) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_166", d_drop_max_dist];
		"d_drop_zone" setMarkerPos _oldpos;
	};
	player sideChat format [localize "STR_DOM_MISSIONSTRING_167", [d_x_drop_type, "CfgVehicles"] call d_fnc_GetDisplayName];
	if (d_with_ranked) then {["d_pas", [player, (d_ranked_a select 16) * -1]] call d_fnc_NetCallEventCTS};
	["d_x_dr_t", [d_x_drop_type, markerPos "d_drop_zone", player]] call d_fnc_NetCallEventCTS;
} else {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_168");
	"d_drop_zone" setMarkerPos _oldpos;
};

if (d_with_ai|| {d_with_ai_features == 0}) then {
	d_drop_blocked = false; publicVariable "d_drop_blocked";
};