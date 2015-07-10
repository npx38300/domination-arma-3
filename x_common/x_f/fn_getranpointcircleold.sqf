//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getranpointcircleold.sqf"
#include "x_setup.sqf"

// no slope check, for patrolling
private ["_center", "_radius", "_center_x", "_center_y", "_ret_val", "_co", "_x1", "_y1"];
_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_center_x = _center select 0;_center_y = _center select 1;
_ret_val = [];
for "_co" from 0 to 99 do {
	_x1 = _center_x + (_radius - (random (2 * _radius)));
	_y1 = _center_y + (_radius - (random (2 * _radius)));
	if !(surfaceIswater [_x1, _y1]) exitWith {_ret_val = [_x1, _y1, 0]};
};
_ret_val