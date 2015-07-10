//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_admindialog.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_display", "_ctrl", "_units", "_index"];

disableSerialization;

if (isMultiplayer && !d_pisadminp) exitWith {
	["d_p_f_b_k", [player, d_name_pl, 3]] call d_fnc_NetCallEventCTS;
};

xr_phd_invulnerable = true;

createDialog "d_AdminDialog";
_ctrl = (uiNamespace getVariable "d_AdminDialog") displayCtrl 1001;

_units = if (isMultiplayer) then {(playableUnits - [objNull])} else {switchableUnits};
lbClear _ctrl;
{
	if (!isNull _x && {str _x != "HC_D_UNIT"}) then {
		_index = _ctrl lbAdd (name _x);
		_ctrl lbSetData [_index, str _x];
	};
} forEach _units;

_ctrl lbSetCurSel 0;
ctrlSetFocus ((uiNamespace getVariable "d_AdminDialog") displayCtrl 1212);

0 spawn {
	scriptName "spawn_d_fnc_admindialog_kicker";
	private ["_ctrl", "_units", "_index"];
	disableSerialization;
	d_a_d_p_kicked = nil;
	_ctrl = (uiNamespace getVariable "d_AdminDialog") displayCtrl 1001;
	while {alive player && {d_admin_dialog_open}} do {
		if (!isNil "d_a_d_p_kicked") then {
			d_a_d_p_kicked = nil;
			lbClear _ctrl;
			_units = if (isMultiplayer) then {(playableUnits - [objNull])} else {switchableUnits};
			{
				if (!isNull _x && {str _x != "HC_D_UNIT"}) then {
					_index = _ctrl lbAdd (name _x);
					_ctrl lbSetData [_index, str _x];
				};
			} forEach _units;
			_ctrl lbSetCurSel 0;
		};
		sleep 0.2;
	};
	if (d_admin_dialog_open) then {
		closeDialog 0;
	};
	xr_phd_invulnerable = false;
	sleep 0.5;
	deleteMarkerLocal "d_admin_marker";
};