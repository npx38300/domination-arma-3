//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_randomarray.sqf"
#include "x_setup.sqf"

// shuffles the content of an array
// parameters: array
// example: _myrandomarray = _myNormalArray call d_fnc_RandomArray;
 private["_ar", "_res", "_idx"];
_ar = _this;
_res = [];
_res resize (count _ar);
for "_i" from 0 to (count _ar -1) do {
	_idx = floor random (_i + 1);
	_res set [_i, _res select _idx];
	_res set [_idx, _ar select _i];
};
_res