//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_squadmgmtlblostfocus.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_butidc", "_carray", "_buctrl"];
_butidc = [_this, 0] call BIS_fnc_param;
_carray = [_this, 1] call BIS_fnc_param;
__TRACE_2("","_butidc","_carray")

disableSerialization;
_butidc = _butidc + 1000;
_buctrl = (uiNamespace getVariable "d_SquadManagementDialog") displayCtrl _butidc;
__TRACE_2("","_butidc","_buctrl")
if (ctrlText _buctrl == "Remove") then {
	_buctrl ctrlSetText "Leave";
};