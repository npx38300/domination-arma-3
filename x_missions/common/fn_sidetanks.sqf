// by Xeno
#define THIS_FILE "fn_sidetanks.sqf"
#include "x_setup.sqf"
private ["_posi_array","_tarray","_dirs"];
if !(call d_fnc_checkSHC) exitWith {};

_posi_array = [_this, 0] call BIS_fnc_param;
_dirs = [_this, 1] call BIS_fnc_param;

d_dead_tanks = 0;

_tarray = [];
for "_ii" from 1 to 6 do {
	_tank1 = createVehicle [d_sm_tank, _posi_array select _ii, [], 0, "NONE"];
	_tank1 setDir (_dirs select 0);
	_tank1 setPos (_posi_array select _ii);
	d_x_sm_vec_rem_ar pushBack _tank1;
	_tank1 addEventHandler ["killed", {
		d_dead_tanks = d_dead_tanks + 1;
		(_this select 0) removeAllEventHandlers "killed";
	}];
	_tank1 lock true;
	_tarray pushBack _tank1;
	sleep 0.512;
};

sleep 2.333;
["specops", 2, "basic", 2, _posi_array select 0, 300, true] spawn d_fnc_CreateInf;
sleep 2.333;
["aa", 1, "tracked_apc", 1, "tank", 1, _posi_array select 0, 2, 400, true] spawn d_fnc_CreateArmor;

_dirs = nil;
_posi_array = nil;

0 spawn {
	sleep 15.321;

	while {d_dead_tanks < 6} do {
		sleep 5.321;
	};

	d_sm_winner = 2;
	d_sm_resolved = true;
	if (d_IS_HC_CLIENT) then {
		["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
	};
};