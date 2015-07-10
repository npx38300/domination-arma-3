// by Xeno
#define THIS_FILE "fn_checktrucktrans.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vec","_enterer"];

_enterer = [_this, 2] call BIS_fnc_param;
if (_enterer != player) exitWith {};

_vec = [_this, 0] call BIS_fnc_param;

if (!d_with_ai && {d_with_ai_features != 0} && {!(str _enterer in d_is_engineer)}) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_182");
	_enterer action["getOut", _vec];
};
