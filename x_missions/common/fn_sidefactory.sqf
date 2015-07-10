// by Xeno
#define THIS_FILE "fn_sidefactory.sqf"
#include "x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private ["_barray"];

_barray = [];
{
	if (isNil "_x") exitWith {};
	if (!isNull _x) then {
		_barray pushBack _x;
	};
} forEach _this;

while {true} do {
	call d_fnc_mpcheck;
	if ({alive _x} count _barray == 0) exitWith {};
	sleep 5.321;
};

d_sm_winner = 2;
d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};