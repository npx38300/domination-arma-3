//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_createtrigger.sqf"
#include "x_setup.sqf"

private ["_pos", "_trigarea", "_trigact", "_trigstatem", "_trigger"];
_pos = [_this, 0] call BIS_fnc_param;
_trigarea = [_this, 1] call BIS_fnc_param;
_trigact = [_this, 2] call BIS_fnc_param;
_trigstatem = [_this, 3] call BIS_fnc_param;
_trigger = if (typeName _pos == "ARRAY") then {
	createTrigger ["EmptyDetector" ,_pos];
} else {
	_pos
};
_trigger setTriggerArea _trigarea;
_trigger setTriggerActivation _trigact;
_trigger setTriggerStatements _trigstatem;
_trigger