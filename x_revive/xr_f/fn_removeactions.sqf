//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_removeactions.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_unit", "_actid"];
_unit = _this;
_actid = _unit getVariable ["xr_ReviveAction", -9999];
if (_actid != -9999) then {
	_unit removeAction _actid;
	_unit setVariable ["xr_ReviveAction", -9999];
};
_actid = _unit getVariable ["xr_DragAction", -9999];
if (_actid != -9999) then {
	_unit removeAction _actid;
	_unit setVariable ["xr_DragAction", -9999];
};
