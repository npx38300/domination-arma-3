// by Xeno
#define THIS_FILE "fn_handleattackgroups.sqf"
#include "x_setup.sqf"
private ["_grps", "_allunits", "_numdown"];

if (!isServer) exitWith {};

_grps = [_this, 0] call BIS_fnc_param;

_allunits = [];
{
	_allunits = [_allunits , units _x] call d_fnc_arrayPushStack;
	sleep 0.011;
} forEach _grps;

sleep 1.2123;

_numdown = 5;

while {!d_mt_radio_down} do {
	call d_fnc_mpcheck;
	if ((_allunits call d_fnc_GetAliveUnits) < _numdown) exitWith {
		d_c_attacking_grps = [];
		d_create_new_paras = true;
	};
	sleep 10.623;
};
