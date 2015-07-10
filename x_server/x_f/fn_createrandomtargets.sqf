// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createrandomtargets.sqf"
#include "x_setup.sqf"

private ["_firstar", "_add"];

_firstar = (count d_target_names) call d_fnc_RandomIndexArray;
__TRACE_1("","_firstar")
_add = [];

for "_i" from 0 to (count _firstar - 2) do {
	_nn = _firstar select _i;
	if (((d_target_names select _nn) select 0) distance ((d_target_names select (_firstar select (_i + 1))) select 0) < 800) then {
		_add pushBack _nn;
		_firstar set [_i, -999];
	};
};

__TRACE_1("","_add")

if !(_add isEqualTo []) then {
	_firstar = _firstar - [-999];
	_firstar = [_firstar, _add] call d_fnc_arraypushstack;
};

__TRACE_1("","_firstar")

_firstar