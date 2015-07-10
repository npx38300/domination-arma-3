//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_posbehind2.sqf"
#include "x_setup.sqf"

private ["_p1", "_p2", "_dist", "_dirn"];
_p1 = [_this, 0] call BIS_fnc_param;
_p2 = [_this, 1] call BIS_fnc_param;
_dist = (random 1300) max 900;
_nvect = (_p2 vectorDiff _p1) vectorMultiply (1 + (_dist / 1000));
__TRACE_1("","_nvect")
_dirn = ([_p1, _p2] call d_fnc_DirTo) + 180;
__TRACE_1("","_dirn")
[_nvect, _dirn, _dist]