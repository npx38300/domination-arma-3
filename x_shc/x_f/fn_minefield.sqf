// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_minefield.sqf"
#include "x_setup.sqf"

private ["_radius", "_center", "_num_mines", "_ran_start_pos", "_m_pos_ar", "_mine"];

_radius = [_this, 0] call BIS_fnc_param;
_center = [_this, 1] call BIS_fnc_param;

_num_mines = (floor (random 20)) max 10;

_ran_start_pos = [_center, _radius] call d_fnc_GetRanPointCircle;
_m_pos_ar = [];

for "_i" from 1 to _num_mines do {
	_m_pos_ar pushBack ([_ran_start_pos, 100] call d_fnc_GetRanPointCircle);
};

d_mines_created = [];
_mtype = ["APERSMine", "APERSBoundingMine", "SLAMDirectionalMine", "APERSTripMine"] call d_fnc_RandomArrayVal;

for "_i" from 0 to (_num_mines - 1) do {
	_mine = createMine [_mtype, _m_pos_ar select _i, [], 0];
	_mine setDir (random 360);
	d_side_enemy revealMine _mine;
	d_mines_created pushBack _mine;
#ifdef __GROUPDEBUG__
	[str _mine, (_m_pos_ar select _i), "ICON", "ColorBlack", [0.5,0.5], "Mine: " + (typeOf _mine), 0, "mil_dot"] call d_fnc_CreateMarkerLocal;
#endif
};
