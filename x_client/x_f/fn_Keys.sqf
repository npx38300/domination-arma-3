// Created by: Dirty Haz

#define THIS_FILE "fn_Keys.sqf"
#include "x_setup.sqf"

disableSerialization;

private ["_D", "_Key", "_Shift", "_Ctrl", "_Alt", "_Handled"];

_D = [_this, 0, objNull] call BIS_fnc_param;
_Key = [_this, 1, objNull] call BIS_fnc_param;
_Shift = [_this, 2, objNull] call BIS_fnc_param;
_Ctrl = [_this, 3, objNull] call BIS_fnc_param;
_Alt = [_this, 4, objNull] call BIS_fnc_param;

_Handled = false;

Key_END = false;

_Default_Key = if (count (actionKeys "User10") == 0) then {207} else {(actionKeys "User10") select 0};

// Earplugs Key
if (_Key == _Default_Key && !_Shift && !_Ctrl && !_Alt && !dialog) then {
if (!Key_END) then {Key_END = true; _Handled = true; nul = [] execVM "x_client\Earplugs.sqf";} else {Key_END = false;};
};

_Handled = true;