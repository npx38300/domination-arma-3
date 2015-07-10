// by Xeno
#define THIS_FILE "fn_shootari.sqf"
#include "x_setup.sqf"
private ["_angle", "_cent_x", "_cent_y", "_height", "_num_shells", "_pos_enemy", "_radius", "_type", "_pos_ar", "_kind"];
if !(call d_fnc_checkSHC) exitWith {};

_pos_enemy = [_this, 0] call BIS_fnc_param;
_kind = [_this, 1] call BIS_fnc_param;

_radius = 30;
_cent_x = _pos_enemy select 0;
_cent_y = _pos_enemy select 1;

_type = if (d_enemy_side == "OPFOR") then {
	switch (_kind) do {
		case 0: {d_ArtyShellsOpfor select 2};
		case 1: {d_ArtyShellsOpfor select 0};
		default {d_ArtyShellsOpfor select 1};
	}
} else {
	switch (_kind) do {
		case 0: {d_ArtyShellsBlufor select 2};
		case 1: {d_ArtyShellsBlufor select 0};
		default {d_ArtyShellsBlufor select 1};
	}
};

if (_kind in [0,1]) then {
	_num_shells = 3 + (ceil random 3);
	if (d_searchintel select 4 == 1) then {["d_doarti", _pos_enemy] call d_fnc_NetCallEventToClients};
} else {
	_num_shells = 1;
}; 

_pos_ar = [];
_height = switch (_kind) do {case 0: {150};case 1: {150}; case 2: {1}};
while {count _pos_ar < _num_shells} do {
	_angle = floor random 360;
	_pos_ar pushBack [_cent_x - ((random _radius) * sin _angle), _cent_y - ((random _radius) * cos _angle), _height];
	sleep 0.0153;
};
sleep 9.25 + (random 8);
for "_i" from 0 to (_num_shells - 1) do {
	_shell = createVehicle [_type, _pos_ar select _i, [], 0, "NONE"];
	_shell setVelocity [0,0,-150];
	 sleep 0.923 + ((ceil random 10) / 10);
};
