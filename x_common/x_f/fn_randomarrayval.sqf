//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_randomarrayval.sqf"
#include "x_setup.sqf"

// get a random item from an array
// parameters: array
// example: _randomval = _myarray call d_fnc_RandomArrayVal;
_this select (_this call d_fnc_RandomFloorArray)