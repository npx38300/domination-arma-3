//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_outofbounds.sqf"
#include "x_setup.sqf"

private ["_p_x", "_p_y", "_ppvec"];
_ppvec = getPosASL _this;
_p_x = _ppvec select 0;
_p_y = _ppvec select 1;
((_p_x < 0 || {_p_x > d_island_x_max}) && {(_p_y < 0 || {_p_y > d_island_y_max})})