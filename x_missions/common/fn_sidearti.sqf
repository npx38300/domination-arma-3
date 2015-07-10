// by Xeno
#define THIS_FILE "fn_sidearty.sqf"
#include "x_setup.sqf"
private ["_angle","_angle_plus","_arti","_arti_pos_dir","_center_x","_center_y","_count_arti","_grp","_i","_pos_array","_poss","_radius","_this","_truck","_unit","_x1","_y1"];
if !(call d_fnc_checkSHC) exitWith {};

_poss = [_this, 0] call BIS_fnc_param;

d_sm_arty_crewman = getText (configFile/"CfgVehicles"/d_sm_arty/"crew");

// calc positions
_center_x = _poss select 0;
_center_y = _poss select 1;
_radius = 30;
_angle = 0;
_pos_array = [];
_count_arti = 8;
_angle_plus = 360 / _count_arti;

for "_i" from 0 to _count_arti - 1 do {
	_x1 = _center_x - (_radius * sin _angle);
	_y1 = _center_y - (_radius * cos _angle);
	_pos_array pushBack [[_x1,_y1,0], _angle];
	_angle = _angle + _angle_plus;
};

d_dead_arti = 0;
_grp = [d_side_enemy] call d_fnc_creategroup;

for "_i" from 0 to (_count_arti - 1) do {
	_arti_pos_dir = _pos_array select _i;
	_arti = createVehicle [d_sm_arty, _arti_pos_dir select 0, [], 0, "NONE"];
	_arti setDir (_arti_pos_dir select 1);
	_arti setPos (_arti_pos_dir select 0);
	d_x_sm_vec_rem_ar pushBack _arti;
	_arti addEventHandler ["killed", {d_dead_arti = d_dead_arti + 1; (_this select 0) removeAllEventHandlers "killed"; {(_this select 0) deleteVehicleCrew _x} forEach (crew (_this select 0))}];
	_arti lock true;
	_arti allowCrewInImmobile true;
	_unit = _grp createUnit [d_sm_arty_crewman, _arti_pos_dir select 0, [], 0, "NONE"];
	_unit call d_fnc_removeNVGoggles;
	_unit call d_fnc_removefak;
	_unit setSkill 1;_unit assignAsGunner _arti;_unit moveInGunner _arti;
	d_x_sm_rem_ar pushBack _unit;
	sleep 0.5321;
};

[_grp, 1] call d_fnc_setgstate;

_pos_array = nil;

for "_i" from 1 to 3 do {
	_truck = createVehicle [d_sm_ammotrucktype, _poss, [], 0, "CAN_COLLIDE"];
	_truck lock true;
	d_x_sm_vec_rem_ar pushBack _truck;
	sleep 0.523;
};

sleep 2.123;
["specops", 3, "basic", 2, _poss, 300,true] spawn d_fnc_CreateInf;
sleep 4.123;
["aa", 1, "tracked_apc", 2, "tank", 1, _poss,1,400,true] spawn d_fnc_CreateArmor;

while {d_dead_arti != _count_arti} do {
	sleep 4.631;
};

d_dead_arti = nil;

d_sm_winner = 2;
d_sm_resolved = true;
d_no_more_observers = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
	["d_sSetVar", ["d_no_more_observers", true]] call d_fnc_NetCallEventCTS;
};