//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_dismissallbuttonaction.sqf"
#include "x_setup.sqf"

if (isDedicated || {player getVariable "d_recdbusy"}) exitWith {};
player setVariable ["d_recdbusy", true];
private ["_control2", "_ctrl", "_control"];
_has_ai = false;
{
	if (!isPlayer _x) then {
		_has_ai = true;
		if (vehicle _x == _x) then {
			deleteVehicle _x;
		} else {
			["d_delvc", [vehicle _x, _x]] call d_fnc_NetCallEventSTO;
		};
	};
} forEach units group player;
if (_has_ai) then {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_216")};
((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1011) ctrlShow false;
((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1012) ctrlShow false;
d_current_ai_num = 0;

_control2 = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1030;
_control2 ctrlSetText format [localize "STR_DOM_MISSIONSTRING_693", d_current_ai_num, d_max_ai];

_ctrl = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1010;
if (!ctrlShown _ctrl) then {
	_ctrl ctrlShow true;
};

_control = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1001;
lbClear _control;

d_current_ai_units = [];
player setVariable ["d_recdbusy", false];