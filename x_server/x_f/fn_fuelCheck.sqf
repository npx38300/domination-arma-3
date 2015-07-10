//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_fuelCheck.sqf"
#include "x_setup.sqf"

private "_vec";
_vec = [_this, 0] call BIS_fnc_param;
_vec setVariable ["d_fuel", (fuel _vec) max 0.1];
_vec removeAllMPEventHandlers "MPKilled";