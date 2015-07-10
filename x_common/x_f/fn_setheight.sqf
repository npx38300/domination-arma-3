//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_setheight.sqf"
#include "x_setup.sqf"

// set only height of an object
// parameters: object, height
// example: [unit1, 30] call d_fnc_SetHeight;
private "_p";
_p = getPosASL (_this select 0);(_this select 0) setPos [_p select 0, _p select 1, _this select 1]