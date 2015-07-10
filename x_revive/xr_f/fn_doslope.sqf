//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_doslope.sqf"
#include "xr_macros.sqf"

private ["_pos", "_sl", "_unit", "_rad", "_found", "_cx", "_cy", "_x1", "_y1"];
_pos = [_this, 0] call BIS_fnc_param;
_sl = [_this, 1] call BIS_fnc_param;
_unit = [_this, 2] call BIS_fnc_param;
_rad = 0;_found = false;
while {_sl >= 0.78} do {
	_cx = _pos select 0;_cy = _pos select 1;
	_rad = _rad + 10;
	for "_ang" from 0 to 345 step 15 do {
		_x1 = _cx - (_rad * sin _ang);
		_y1 = _cy - (_rad * cos _ang);
		_sl = [[_x1, _y1, 0], 1] call d_fnc_GetSlope;
		if (_sl < 0.78) exitWith {
			_pos = [_x1, _y1, 0];
			_found = true;		
		};
	};
	if (_found) exitWith {};
};
if (_found) then {_unit setPos [_pos select 0, _pos select 1, _unit distance _pos]};