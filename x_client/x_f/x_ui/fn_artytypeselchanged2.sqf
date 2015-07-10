// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_artytypeselchanged2.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_selection", "_control", "_selectedIndex", "_mag", "_wpos", "_warty", "_inrange", "_eta", "_ctrl"];
disableSerialization;
_selection = [_this, 0] call BIS_fnc_param;

_selectedIndex = _selection select 1;
if (_selectedIndex == -1) exitWith {};

_control = _selection select 0;
_mag = _control lbData _selectedIndex;

_wpos = markerPos "d_temp_mark_arty_marker";

_warty = d_ao_arty_vecs select 0;

_inrange = _wpos inRangeOfArtillery [[_warty], _mag];

__TRACE_3("","_mag","_wpos","_warty")
__TRACE_1("","_inrange")

_eta = if (_inrange) then {_warty getArtilleryETA [_wpos, _mag]} else {0};

_ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 900;
_ctrl ctrlSetText format [localize "STR_DOM_MISSIONSTRING_1458", round _eta];

_ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 890;
if (_inrange) then {
	_ctrl ctrlSetText localize "STR_DOM_MISSIONSTRING_1244b";
	_ctrl ctrlEnable true;
} else {
	_ctrl ctrlSetText localize "STR_DOM_MISSIONSTRING_1244a";
	_ctrl ctrlEnable false;
};