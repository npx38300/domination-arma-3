//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_sidempkilled.sqf"
#include "x_setup.sqf"

private ["_vec"];
_vec = [_this, 0] call BIS_fnc_param;

d_allunits_add pushBack _vec;

_vec removeAllMPEventHandlers "MPKilled";
