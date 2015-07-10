//#define __DEBUG__
#define THIS_FILE "fn_getslope.sqf"
#include "x_setup.sqf"

// from warfare
// Returns an average slope value of terrain within passed radius.
// a little bit modified. no need to create a "global" logic, local is enough, etc
// parameters: position, radius
// example: _slope = [the_position, the_radius] call d_fnc_GetSlope;
private ["_position", "_radius", "_centerHeight", "_height", "_direction"];
_position = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
d_SlopeObject setPos _position;
_centerHeight = getPosASL d_SlopeObject select 2;
_height = 0;_direction = 0;
for "_w" from 0 to 7 do {
	d_SlopeObject setPos [(_position select 0) + ((sin _direction) * _radius), (_position select 1) + ((cos _direction) * _radius), 0];
	_direction = _direction + 45;
	_height = _height + abs (_centerHeight - (getPosASL d_SlopeObject select 2));
};
_height / 8