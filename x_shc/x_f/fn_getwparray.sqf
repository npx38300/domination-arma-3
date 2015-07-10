//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getwparray.sqf"
#include "x_setup.sqf"

private["_tc", "_wp_a","_point","_pos_center","_radius"];
_tc = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_wp_a = [];_wp_a resize 100;
for "_i" from 0 to 99 do {
	_point = [_tc, _radius] call d_fnc_GetRanPointCircle;
	if (_point isEqualTo []) then {
		for "_e" from 0 to 150 do {
			_point = [_tc, _radius] call d_fnc_GetRanPointCircle;
			if !(_point isEqualTo []) exitWith {};
		};
	};
	if !(_point isEqualTo []) then {_wp_a set [_i, _point]};
};
_wp_a