// by Xeno
#define THIS_FILE "fn_teleportx.sqf"
#include "x_setup.sqf"
private ["_ok","_vehicle"];

if (isDedicated) exitWith {};

if (vehicle player != player) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_583")};

if (!isNull (flag player)) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_584")};

if (underwater player) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_585")};

if (dialog) then {closeDialog 0};

d_beam_target = "";
d_tele_dialog = if (d_WithTeleToBase == 0) then {
	2 // 0 = respawn, 1 = teleport
} else {
	1
};

disableSerialization;

createDialog "d_TeleportDialog";

#define __CTRL(A) (_display displayCtrl A)

_display = (uiNamespace getVariable "d_TeleportDialog");
__CTRL(100102) ctrlSetText (localize "STR_DOM_MISSIONSTRING_533");
__CTRL(100111) ctrlSetText (localize "STR_DOM_MISSIONSTRING_586");

d_x_loop_end = false;

0 spawn {
	scriptName "spawn_teleportx_teleupdate";
	while {!d_x_loop_end && {alive player} && {dialog}} do {
		if (!d_x_loop_end && {alive player}) then {[0] call d_fnc_teleupdate_dlg};
		sleep 1.012;
	};
	if (!alive player) then {closeDialog 0};
};