//#define __DEBUG__
#define THIS_FILE "fn_selectcrew.sqf"
#include "x_setup.sqf"

/*
File: selectCrew.sqf
Author: Joris-Jan van 't Land

Description:
Return an appropriate crew type for a certain vehicle.

Parameter(s):
_this select 0: side (Side)
_this select 1: vehicle config entry (Config)

Returns:
Array - crew type, cargo types (array) for Wheeled APCs
*/
if (count _this < 2) exitWith {[]};
private ["_side", "_entry", "_type"];
_side = [_this, 0] call BIS_fnc_param;
_entry = [_this, 1] call BIS_fnc_param;
_type = [_this, 2] call BIS_fnc_param;
if (typeName _side != "SIDE" || {typeName _entry != "CONFIG"}) exitWith {[]};
private ["_crew", "_typcargo"];
_typcargo = [];
_crew = getText (_entry/"crew");
if (_crew == "") then {
	switch (_side) do {
		case blufor: {_crew = d_vec_spawn_default_Crew select 0};
		case opfor: {_crew = d_vec_spawn_default_Crew select 1};
		case independent: {_crew = d_vec_spawn_default_Crew select 2};
		default {};
	};
} else {
	if (_type isKindOf "Car" || {_type isKindOf "Tracked_APC"}) then {
		_typcargo = (getArray (_entry/"typicalCargo")) - [_crew, "Soldier"];
	};
};
[_crew, _typcargo]