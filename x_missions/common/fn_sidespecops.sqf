// by Xeno
#define THIS_FILE "fn_sidespecops.sqf"
#include "x_setup.sqf"
private ["_poss", "_fire", "_radius", "_angle", "_i", "_x1", "_y1", "_tent", "_grps", "_units", "_endnum"];
if !(call d_fnc_checkSHC) exitWith {};

_poss = [_this, 0] call BIS_fnc_param;

_fire = createVehicle ["Campfire_burning_F", _poss, [], 0, "NONE"];
_fire setPos _poss;
d_x_sm_vec_rem_ar pushBack _fire;
sleep 0.01;

_center_x = _poss select 0;
_center_y = _poss select 1;
_radius = 5;
_angle = 0;
_pos_array = [];
_angle_plus = 360 / 4;

for "_i" from 0 to 3 do {
	_x1 = _center_x - (_radius * sin _angle);
	_y1 = _center_y - (_radius * cos _angle);
	_pos_array pushBack [[_x1,_y1,0], _angle];
	_angle = _angle + _angle_plus;
};


for "_i" from 0 to 3 do {
	_obj_pos_dir = _pos_array select _i;
	_tent = createVehicle [d_sm_tent, _obj_pos_dir select 0, [], 0, "NONE"];
	_tent setDir (_obj_pos_dir select 1);
	_tent setPos (_obj_pos_dir select 0);
	d_x_sm_vec_rem_ar pushBack _tent;
	sleep 0.2321;
};

_pos_array = nil;

_grps = ["specops", 3, "basic", 0, _poss , 150, true] call d_fnc_CreateInf;
_units = [];
{
	_units = [_units, units _x] call d_fnc_arrayPushStack
} forEach _grps;

d_num_species = 0;

{
	_x allowFleeing 0;
	_x addEventHandler ["killed", {d_num_species = d_num_species + 1; (_this select 0) removeAllEventHandlers "killed"}];
} forEach _units;

sleep 2.123;
_endnum = (count _units) - 2;

while {d_num_species < _endnum} do {
	{
		if (alive _x && {(_x distance _poss) >= 400}) then {
			_x setDamage 1;
			sleep 0.1;
		};
	} forEach _units;
	sleep 4.631;
};

_units = nil;

d_sm_winner = 2;
d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};
d_num_species = nil;