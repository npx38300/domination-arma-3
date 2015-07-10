//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_squadmgmtlockbuttonclicked.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_grp", "_lockedgr", "_disp", "_ctrl", "_ctrl2"];
_grp = group player;
_lockedgr = _grp getVariable ["d_locked", false];
__TRACE_2("","_grp","_lockedgr")
disableSerialization;
_disp = (uiNamespace getVariable "d_SquadManagementDialog");
_ctrl = _disp displayCtrl _this;
_ctrl2 = _disp displayCtrl (6000 + (_this - 7000));
if (_lockedgr) then {
	_grp setVariable ["d_locked", false, true];
	_ctrl ctrlSetText (localize "STR_DOM_MISSIONSTRING_1449");
	_ctrl2 ctrlShow false;
} else {
	_grp setVariable ["d_locked", true, true];
	_ctrl ctrlSetText (localize "STR_DOM_MISSIONSTRING_1450");
	_ctrl2 ctrlShow true;
};