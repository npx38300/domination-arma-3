// by Xeno
#define THIS_FILE "fn_beam_tele.sqf"
#include "x_setup.sqf"
#define __CTRL2(A) (_display displayCtrl A)
private ["_display", "_ctrl", "_typepos", "_wone", "_global_pos", "_global_dir"];
if (isDedicated || {d_beam_target == ""} || {d_x_loop_end}) exitWith {};

d_x_loop_end = true;

if (vehicle player != player) then {unassignVehicle player};

_wone = [_this, 0] call BIS_fnc_param;

disableSerialization;
_display = if (_wone == 0) then {(uiNamespace getVariable "d_TeleportDialog")} else {(uiNamespace getVariable "xr_SpectDlg")};
if (_wone == 0) then {
	__CTRL2(100102) ctrlEnable false;
	__CTRL2(100107) ctrlEnable false;
	__CTRL2(100108) ctrlEnable false;
	__CTRL2(100109) ctrlEnable false;
} else {
	__CTRL2(3000) ctrlShow false;
};

d_last_telepoint = d_beam_target;

_global_pos = [];
_global_dir = 180;
_typepos = 0;

if (d_beam_target == "D_BASE_D") then {
	_global_pos = markerPos "base_spawn_1";
} else {
	_mrs = missionNamespace getVariable [d_beam_target, objNull];
	_global_pos = _mrs modelToWorldVisual [0,-7,0];
	_global_pos set [2,0];
	_global_dir = getDirVisual _mrs;
	_typepos = 1;
};

d_beam_target = "";

if (_typepos == 1) then {
	player setDir _global_dir;
	player setPosATL [_global_pos select 0, _global_pos select 1, 0];
} else {
	player setDir _global_dir;
	player setPos _global_pos;
};
_wone spawn {
	private "_nobs";
	sleep 2;
	if (_this == 0) then {
		if (d_teleport_dialog_open) then {closeDialog 0};
		titleText ["", "BLACK IN"];
	};

	_nobs = nearestObjects [player, d_rev_respawn_vec_types, 30];
	{player reveal _x} forEach _nobs;

	if (d_with_ai && {alive player} && {!(player getVariable ["xr_pluncon", false])}) then {[] spawn d_fnc_moveai};
};