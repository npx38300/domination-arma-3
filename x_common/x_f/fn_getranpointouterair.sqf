//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getranpointouterair.sqf"
#include "x_setup.sqf"

// get a random point at the borders of the current island for spawning air vehicles (no slope check, no is water check, etc)
// parameters:
// center position, left x, left y, width, height, angle (optional)
private ["_pos", "_centerx", "_centery", "_width", "_height", "_rside", "_px1", "_py1", "_radius", "_atan"];
_pos = d_island_center;
_centerx = _pos select 0; _centery = _pos select 1;
_width = (2 * (_pos select 0)) - 500;
_height = (2 * (_pos select 1)) - 500;
_rside = floor (random 4);
_px1 = switch (_rside) do {
	case 0: {250 + random _width};
	case 1: {250 + _width};
	case 2: {250 + random _width};
	case 3: {250};
};
_py1 = switch (_rside) do {
	case 0: {250 + _height};
	case 1: {250 + random _height};
	case 2: {250};
	case 3: {250 + random _height};
};
_radius = _pos distance [_px1,_py1,_pos select 2];
_atan = (_centerx - _px1) atan2 (_centery - _py1);
[_centerx - (_radius * sin _atan), _centery - (_radius * cos _atan), 300]