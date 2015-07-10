//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getranpointcircleouter.sqf"
#include "x_setup.sqf"

// get a random point at the borders of a circle
// parameters:
// center position, radius of the circle
// example: _random_point = [position trigger1, 200] call d_fnc_GetRanPointCircleOuter;
private ["_center", "_radius", "_co", "_angle", "_center_x", "_center_y"];
_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_center_x = _center select 0;_center_y = _center select 1;
_ret_val = [];
for "_co" from 0 to 100 do {
	_angle = floor (random 360);
	_posee = [_center_x - (_radius * sin _angle), _center_y - (_radius * cos _angle), 0];
	_isFlat = _posee isFlatEmpty [
		2,	//--- Minimal distance from another object
		0,				//--- If 0, just check position. If >0, select new one
		0.7,				//--- Max gradient
		4,	//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,				//--- True if some water can be in 25m radius
		objNull			//--- Ignored object
	];
	if !(_isFlat isEqualTo []) exitWith {
		_ret_val = ASLToATL _isFlat;
	};
};
_ret_val