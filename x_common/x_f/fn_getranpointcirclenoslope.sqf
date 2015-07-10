//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getranpointcirclenoslope.sqf"
#include "x_setup.sqf"

// get a random point inside a circle
// parameters:
// center position, radius of the circle
// example: _random_point = [position trigger1, 200] call d_fnc_GetRanPointCircleNoSlope;
private ["_center", "_radius", "_co", "_center_x", "_center_y"];
_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_center_x = _center select 0;_center_y = _center select 1;
_ret_val = [];
for "_co" from 0 to 99 do {
	_posee = [_center_x + (_radius - (random (2 * _radius))), _center_y + (_radius - (random (2 * _radius))), 0];
	_isFlat = _posee isFlatEmpty [
		1,	//--- Minimal distance from another object
		0,				//--- If 0, just check position. If >0, select new one
		1,				//--- Max gradient
		2,	//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,				//--- True if some water can be in 25m radius
		objNull			//--- Ignored object
	];
	if !(_isFlat isEqualTo []) exitWith {
		_ret_val = ASLToATL _isFlat;
	};
};
_ret_val