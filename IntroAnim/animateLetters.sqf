#define THIS_FILE "animateLetters.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_chars","_mode","_display","_idcPool","_Slot","_ctrl"];

disableSerialization;

_chars = [_this, 0] call BIS_fnc_param;
_mode = "";
_display = (uiNamespace getVariable "d_RscAnimatedLetters");
_Slot = 0;

switch (_this select 1) do  {
	case 0: {_mode = "IntroAnim\animateLetter.sqf";_Slot = 0};
	case 1: {_mode = "IntroAnim\animateLetter1.sqf";_Slot = 30};
	case 2: {_mode = "IntroAnim\animateLetter2.sqf";_Slot = 60};
	case 3: {_mode = "IntroAnim\animateLetter.sqf";_Slot = 90};
	case 4: {_mode = "IntroAnim\animateLetter1.sqf";_Slot = 120};
	case 5: {_mode = "IntroAnim\animateLetter2.sqf";_Slot = 150};
	case 6: {_mode = "IntroAnim\animateLetter1.sqf";_Slot = 180};
	default {};
};
private "_idcPool";
_idcPool = 5000;
d_animL_controls = [];
_doexit = false;
for "_i" from _Slot to (_Slot + 30) do {
	if (isNil "_display") exitWith {
			createDialog "d_RscAnimatedLetters";
			_display = (uiNamespace getVariable "d_RscAnimatedLetters");
	};
	_ctrl = _display displayCtrl (_idcPool + _i);
	d_animL_controls pushBack _ctrl;
	waitUntil{isNil "_ctrl" || {ctrlCommitted _ctrl}};
	if (isNil "_ctrl") exitWith {_doexit = true};
};
if (_doexit) exitWith {};
for "_i" from 0 to 29 do {
	sleep 0.06;
	_ctrl = d_animL_controls select 0;
	if !(isNil "_ctrl") then {[_ctrl, _chars select _i, _i, _Slot] execVM _mode};
	sleep 0.06;
};
d_animL_i = d_animL_i + 1;
true