//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_progbarcall.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_wf", "_disp", "_control", "_maxWidth", "_position", "_newval"];
_wf = [_this, 0] call BIS_fnc_param;
disableSerialization;
_disp = (uiNamespace getVariable "d_ProgressBar");
_control = _disp displayCtrl 3800;
_maxWidth = (ctrlPosition (_disp displayCtrl 3600) select 2);
_position = ctrlPosition _control;
_newval = if ((_wf getVariable "d_SIDE") != d_own_side_trigger_alt) then {((_maxWidth * (_wf getVariable "d_CURCAPTIME") / (_wf getVariable "d_CAPTIME")) min _maxWidth) max 0.02} else {_maxWidth};
_position set [2, _newval];
//progressSetPosition
_control ctrlSetPosition _position;
_control ctrlSetBackgroundColor (if !(_wf getVariable "d_STALL") then {[1 - (_newval * 2.777777), _newval * 2.777777, 0, 0.8]} else {[1, 1, 0, 0.8]});
_control ctrlCommit 3;