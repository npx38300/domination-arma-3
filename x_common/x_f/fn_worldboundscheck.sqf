//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_worldboundscheck.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")
private "_pos";
_pos = _this;
if (_pos isEqualTo []) exitWith {
	_pos;
};
if (_pos select 0 < 0) then {
	_pos set [0, 300];
} else {
	if (_pos select 0 > (d_island_x_max - 2)) then {
		_pos set [0, d_island_x_max - 300];
	};
};
if (_pos select 1 < 0) then {
	_pos set [1, 300];
} else {
	if (_pos select 1 > (d_island_y_max - 2)) then {
		_pos set [1, d_island_y_max - 300];
	};
};
__TRACE_1("","_pos")
_pos