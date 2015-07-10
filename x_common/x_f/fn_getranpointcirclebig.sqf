//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getranpointcirclebig.sqf"
#include "x_setup.sqf"

// get a random point inside a circle for bigger objects
// parameters:
// center position, radius of the circle
// example: _random_point = [position trigger1, 200] call d_fnc_GetRanPointCircleBig;
private ["_center", "_radius", "_co", "_center_x", "_center_y"];
_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_center_x = _center select 0;_center_y = _center select 1;
_ret_val = [];
for "_co" from 0 to 99 do {
	_posee = [_center_x + (_radius - (random (2 * _radius))), _center_y + (_radius - (random (2 * _radius))), 0];
	_isFlat = _posee isFlatEmpty [
		9,	//--- Minimal distance from another object
		0,				//--- If 0, just check position. If >0, select new one
		0.7,				//--- Max gradient
		13,	//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,				//--- True if some water can be in 25m radius
		objNull			//--- Ignored object
	];
	if (!(_isFlat isEqualTo []) && {!isOnRoad _isFlat}) exitWith {
		_ret_val = ASLToATL _isFlat;
	};
};
__TRACE_1("","_ret_val")
_ret_val