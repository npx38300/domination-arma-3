//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getwparray3.sqf"
#include "x_setup.sqf"

private ["_pos","_a","_b","_angle","_wp_a","_point"];
_pos = [_this, 0] call BIS_fnc_param;
_a = [_this, 1] call BIS_fnc_param;
_b = [_this, 2] call BIS_fnc_param;
_angle = [_this, 3] call BIS_fnc_param;
_wp_a = [];_wp_a resize 100;
for "_i" from 0 to 99 do {
	_point = [_pos, _a, _b, _angle] call d_fnc_GetRanPointSquare;
	if (_point isEqualTo []) then {
		for "_e" from 0 to 150 do {
			_point = [_pos, _a, _b, _angle] call d_fnc_GetRanPointSquare;
			if !(_point isEqualTo []) exitWith {};
		};
	};
	if !(_point isEqualTo []) then {_wp_a set [_i, _point]};
};
_wp_a