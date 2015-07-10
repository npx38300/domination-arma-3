//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_dismissbuttonaction.sqf"
#include "x_setup.sqf"

__TRACE("dismissbuttonaction")
if (isDedicated || {player getVariable "d_recdbusy"}) exitWith {};
player setVariable ["d_recdbusy", true];
__TRACE("dismissbuttonaction2")
private ["_control", "_idx", "_unit", "_ctrl", "_control2"];
_control = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1001;
_idx = lbCurSel _control;
__TRACE_1("",_idx)
if (_idx == -1) exitWith {
	player setVariable ["d_recdbusy", false];
};

d_current_ai_num = d_current_ai_num - 1;
__TRACE_1("","d_current_ai_num")

_control lbDelete _idx;

_unit = d_current_ai_units select _idx;
d_current_ai_units set [_idx, -1];
d_current_ai_units = d_current_ai_units - [-1];

if (!isPlayer _unit) then {
	if (vehicle _unit == _unit) then {
		deleteVehicle _unit;
	} else {
		["d_delvc", [vehicle _unit, _unit]] call d_fnc_NetCallEventSTO;
	};
};

_ctrl = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1010;
if (!ctrlShown _ctrl) then {
	_ctrl ctrlShow true;
};

if (d_current_ai_num == 0) then {
	((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1011) ctrlShow false;
	((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1012) ctrlShow false;
};

_control2 = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1030;
_control2 ctrlSetText format [localize "STR_DOM_MISSIONSTRING_693", d_current_ai_num, d_max_ai];
player setVariable ["d_recdbusy", false];