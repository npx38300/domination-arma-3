//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_fillunload.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_control", "_pic", "_index"];
disableSerialization;
_control = (uiNamespace getVariable "d_UnloadDialog") displayCtrl 101115;
lbClear _control;

{
	_pic = getText (configFile/"cfgVehicles"/_x/"picture");
	_index = _control lbAdd ([_x, "CfgVehicles"] call d_fnc_GetDisplayName);
	_control lbSetPicture [_index, _pic];
	_control lbSetColor [_index, [1, 1, 0, 0.8]];
} forEach d_current_truck_cargo_array;

_control lbSetCurSel 0;