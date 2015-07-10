//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getrandomrangeint.sqf"
#include "x_setup.sqf"

// gets a random integer number in a specific range
// parameters: integer from, integer to (second number must be greater than first)
// example: _random_integer = [30,150] call d_fnc_GetRandomRangeInt;
private ["_num1","_num2","_ra"];
_num1 = [_this, 0] call BIS_fnc_param;
_num2 = [_this, 1] call BIS_fnc_param;
if (_num1 > _num2) then {
	_num2 = [_this, 0] call BIS_fnc_param;
	_num1 = [_this, 1] call BIS_fnc_param;
};
_ra = (_num2 - _num1) call d_fnc_RandomFloor;
(_num1 + _ra)