//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_pmselchanged.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_selection", "_selectedIndex"];
disableSerialization;
_selection = [_this, 0] call BIS_fnc_param;

_selectedIndex = _selection select 1;
if (_selectedIndex == -1) exitWith {};

if (d_show_player_marker != _selectedIndex) then {
	d_show_player_marker = _selectedIndex;
	call d_fnc_deleteplayermarker;
};