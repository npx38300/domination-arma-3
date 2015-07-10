// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getranpointcircle.sqf"
#include "x_setup.sqf"

// get a random point inside a circle
// parameters:
// center position, radius of the circle
// example: _random_point = [position trigger1, 200] call d_fnc_GetRanPointCircle;
private ["_rcenter", "_rradius", "_co", "_center_x", "_center_y", "_posee","_isFlat"];
_rcenter = [_this, 0] call BIS_fnc_param;
_rradius = [_this, 1] call BIS_fnc_param;
__TRACE_2("","_rcenter","_rradius")
_center_x = _rcenter select 0;_center_y = _rcenter select 1;
_ret_val = [];
for "_co" from 0 to 150 do {
	_posee = [_center_x + (_rradius - (random (2 * _rradius))), _center_y + (_rradius - (random (2 * _rradius))), 0];
	__TRACE_1("","_posee")
	_isFlat = _posee isFlatEmpty [
		2,	//--- Minimal distance from another object
		0,				//--- If 0, just check position. If >0, select new one
		0.7,				//--- Max gradient
		4,	//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,				//--- True if some water can be in 25m radius
		objNull			//--- Ignored object
	];
	__TRACE_1("","_isFlat")
	if !(_isFlat isEqualTo []) exitWith {
		_ret_val = ASLToATL _isFlat;
	};
};
__TRACE_1("","_ret_val")
_ret_val