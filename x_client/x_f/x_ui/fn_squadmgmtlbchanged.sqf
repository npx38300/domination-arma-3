//#define __DEBUG__
// by Xeno
disableSerialization;
#define THIS_FILE "fn_squadmgmtlbchanged.sqf"
#include "x_setup.sqf"

#define CTRL(A) (_disp displayCtrl A)

if (isDedicated || {d_sqtmgmtblocked}) exitWith {};

private ["_idc", "_car", "_idx", "_ctrl", "_diff", "_grp", "_disp", "_button", "_lbsel"];
_idc = [_this, 0] call BIS_fnc_param;
_car = [_this, 1] call BIS_fnc_param;
__TRACE_2("","_idc","_car")
_idx = _car select 1;
if (_idx == -1) exitWith {};
_ctrl = _car select 0;

_prevv = uiNamespace getVariable ["d_prev_lb_arc", controlNull];
if (_prevv != _ctrl) then {
	if (!isNull _prevv)then {
		_prevv lbSetCurSel -1;
	};
	uiNamespace setVariable ["d_prev_lb_arc", _ctrl];
};

_diff = _idc - 2000;

__TRACE_3("","_idx","_ctrl","_diff")

_grp = d_SQMGMT_grps select _diff;
disableSerialization;
_disp = (uiNamespace getVariable "d_SquadManagementDialog");
_button = 3000 + _diff;

__TRACE_2("","_grp","_button")

if (group player == _grp && {player == leader _grp}) then {
	_lbsel = _ctrl lbText _idx;
	if (name player != _lbsel) then {
		CTRL(_button) ctrlSetText "Remove";
	} else {
		CTRL(_button) ctrlSetText "Leave";
	};
};