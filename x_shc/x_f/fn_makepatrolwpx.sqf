//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_makepatrolwpx.sqf"
#include "x_setup.sqf"

// supports also patrols in square areas, including angle
private ["_grp", "_start_pos", "_wp_array", "_wp_pos", "_counter", "_wp", "_cur_pos","_no_pos_found", "_wpstatements", "_timeout", "_wp1"];
_grp = [_this, 0] call BIS_fnc_param;
_start_pos = [_this, 1] call BIS_fnc_param;
if (typeName _start_pos == "OBJECT") then {_start_pos = getPosATL _start_pos};
if (typeName _start_pos != "ARRAY" || {_start_pos isEqualTo []} || {isNull _grp}) exitWith {};
_wp_array = [_this, 2] call BIS_fnc_param;
__TRACE_3("","_grp","_start_pos","_wp_array")
if (typeName _wp_array == "OBJECT") then {_wp_array = getPosATL _wp_array};
if (typeName _wp_array != "ARRAY") exitWith {};
_timeout = [_this, 3, []] call BIS_fnc_param;
_wpstatements = [_this, 4, ""] call BIS_fnc_param;
_grp setBehaviour "SAFE";
_cur_pos = _start_pos;
_no_pos_found = false;
for "_i" from 0 to (2 + (floor (random 3))) do {
	_wp_pos = switch (count _wp_array) do {
		case 2: {[_wp_array select 0, _wp_array select 1] call d_fnc_GetRanPointCircle};
		case 4: {[_wp_array select 0, _wp_array select 1, _wp_array select 2, _wp_array select 3] call d_fnc_GetRanPointSquare};
	};
	if (_wp_pos isEqualTo []) exitWith {_no_pos_found = true};
	_counter = 0;
	while {_wp_pos distance _cur_pos < ((_wp_array select 1)/6) && {_counter < 100}} do {
		_wp_pos = switch (count _wp_array) do {
			case 2: {[_wp_array select 0, _wp_array select 1] call d_fnc_GetRanPointCircle};
			case 4: {[_wp_array select 0, _wp_array select 1, _wp_array select 2, _wp_array select 3] call d_fnc_GetRanPointSquare};
		};
		if (_wp_pos isEqualTo []) exitWith {};
		_counter = _counter + 1;
	};
	if (_wp_pos isEqualTo []) exitWith {_no_pos_found = true};
	_wp_pos = _wp_pos call d_fnc_WorldBoundsCheck;
	_cur_pos = _wp_pos;
	_wp = _grp addWaypoint [_wp_pos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius (0 + random 10);
	if !(_timeout isEqualTo []) then {
		_wp setWaypointTimeout _timeout;
	};
	
	if (_i == 0) then {
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointFormation "STAG COLUMN";
	};
	if (_wpstatements != "") then {
		_wp setWaypointStatements ["TRUE", _wpstatements];
	};
};
if (_no_pos_found) exitWith {
	_wp1 = _grp addWaypoint [_start_pos, 0];
	_wp1 setWaypointType "SAD";
};
_wp1 = _grp addWaypoint [_start_pos, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointCompletionRadius (10 + random 10);
if !(_timeout isEqualTo []) then {
	_wp1 setWaypointTimeout _timeout;
};
if (_wpstatements != "") then {
	_wp1 setWaypointStatements ["TRUE", _wpstatements];
};
_wp = _grp addWaypoint [_start_pos, 0];
_wp setWaypointType "CYCLE";
_wp setWaypointCompletionRadius (10 + random 10);