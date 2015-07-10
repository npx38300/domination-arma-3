//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_glselchanged.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_selection", "_selectedIndex"];
disableSerialization;
_selection = [_this, 0] call BIS_fnc_param;

_selectedIndex = _selection select 1;
if (_selectedIndex == -1) exitWith {};

if (d_graslayer_index != _selectedIndex) then {
	d_graslayer_index = _selectedIndex;
	setTerrainGrid ([50, 25, 12.5] select d_graslayer_index);

	systemChat format [localize "STR_DOM_MISSIONSTRING_686", [localize "STR_DOM_MISSIONSTRING_359", localize "STR_DOM_MISSIONSTRING_360", localize "STR_DOM_MISSIONSTRING_361"] select d_graslayer_index];
};