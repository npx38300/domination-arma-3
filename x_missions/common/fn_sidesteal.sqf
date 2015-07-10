// by Xeno
#define THIS_FILE "fn_sidesteal.sqf"
#include "x_setup.sqf"
private ["_reached_base","_vehicle"];
if !(call d_fnc_checkSHC) exitWith {};

_vehicle = [_this, 0] call BIS_fnc_param;

sleep 10.213;

_reached_base = false;

while {alive _vehicle && {!_reached_base}} do {
	call d_fnc_mpcheck;
	if (_vehicle distance d_FLAG_BASE < 100) then {_reached_base = true};
	sleep 5.2134;
};

if (alive _vehicle && {_reached_base}) then {
	d_sm_winner = 2;
} else {
	d_sm_winner = -600;
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};