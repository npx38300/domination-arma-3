// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createmaintarget.sqf"
#include "x_setup.sqf"
private ["_type_list_guard", "_selectit", "_type_list_guard_static", "_type_list_patrol", "_type_list_guard_static2", "_trgobj", "_radius","_number_basic_guard", "_selectitmen", "_number_specops_guard","_number_tank_guard", "_selectitvec", "_number_tracked_apc_guard", "_number_wheeled_apc_guard", "_number_jeep_mg_guard", "_number_jeep_gl_guard", "_number_basic_patrol", "_selectitmen", "_number_specops_patrol", "_number_tank_patrol", "_number_tracked_apc_patrol", "_number_wheeled_apc_patrol", "_number_jeep_mg_patrol", "_number_jeep_gl_patrol", "_number_basic_guardstatic", "_number_specops_guardstatic", "_number_tank_guardstatic", "_number_tracked_apc_guardstatic", "_number_aa_guardstatic", "_number_stat_mg_guardstatic", "_number_stat_gl_guardstatic", "_trg_center", "_trgobj", "_wp_array", "_radius", "_xx", "_type_list_guard", "_typeidx", "_number_", "_xxx", "_wp_ran", "_type_list_guard_static", "_type_list_guard_static2", "_point", "_ccc", "_type_list_patrol", "_baseran", "_fbobjs", "_dgrp", "_unit_array", "_agrp", "_xx_ran", "_xpos", "_units", "_patrol_radius", "_wp_array_pat"];

if !(call d_fnc_checkSHC) exitWith {};

_selectit = {
	(ceil (random (((_this select 0) select (_this select 1)) select 1)))
};

_selectitmen = {
	private ["_a_vng2","_num_ret"];
	_a_vng2 = (_this select 0) select (_this select 1);
	if ((_a_vng2 select 0) > 0) then {_num_ret = floor (random ((_a_vng2 select 0) + 1));if (_num_ret < (_a_vng2 select 1)) then {_a_vng2 select 1} else {_num_ret}} else {0}
};

_selectitvec = {
	private ["_a_vng2","_num_ret"];
	_a_vng2 = ((_this select 0) select (_this select 1)) select 0;
	if ((_a_vng2 select 0) > 0) then {_num_ret = floor (random ((_a_vng2 select 0) + 1));if (_num_ret < (_a_vng2 select 1)) then {_a_vng2 select 1} else {_num_ret}} else {0}
};

_type_list_guard = [
	["basic", 0, [d_footunits_guard, 0] call _selectitmen],
	["specops", 0, [d_footunits_guard, 1] call _selectitmen],
	["tank", [d_vehicle_numbers_guard, 0] call _selectit, [d_vehicle_numbers_guard,0] call _selectitvec],
	["tracked_apc", [d_vehicle_numbers_guard, 1] call _selectit, [d_vehicle_numbers_guard,1] call _selectitvec],
	["wheeled_apc", [d_vehicle_numbers_guard, 2] call _selectit, [d_vehicle_numbers_guard,2] call _selectitvec],
	["jeep_mg", [d_vehicle_numbers_guard, 3] call _selectit, [d_vehicle_numbers_guard,3] call _selectitvec],
	["jeep_gl", [d_vehicle_numbers_guard, 4] call _selectit, [d_vehicle_numbers_guard,4] call _selectitvec]
];

_type_list_guard_static = [
	["basic", 0, [d_footunits_guard_static, 0] call _selectitmen],
	["specops",0, [d_footunits_guard_static, 1] call _selectitmen],
	["tank", [d_vehicle_numbers_guard_static, 0] call _selectit, [d_vehicle_numbers_guard_static,0] call _selectitvec],
	["tracked_apc", [d_vehicle_numbers_guard_static, 1] call _selectit, [d_vehicle_numbers_guard_static,1] call _selectitvec],
	["aa", [d_vehicle_numbers_guard_static, 2] call _selectit, [d_vehicle_numbers_guard_static,2] call _selectitvec]
];

_type_list_patrol = [
	["basic", 0, [d_footunits_patrol, 0] call _selectitmen],
	["specops", 0, [d_footunits_guard_static, 1] call _selectitmen],
	["tank", [d_vehicle_numbers_patrol, 0] call _selectit, [d_vehicle_numbers_patrol,0] call _selectitvec],
	["tracked_apc", [d_vehicle_numbers_patrol, 1] call _selectit, [d_vehicle_numbers_patrol,1] call _selectitvec],
	["wheeled_apc", [d_vehicle_numbers_patrol, 2] call _selectit, [d_vehicle_numbers_patrol,2] call _selectitvec],
	["jeep_mg", [d_vehicle_numbers_patrol, 3] call _selectit, [d_vehicle_numbers_patrol,3] call _selectitvec],
	["jeep_gl", [d_vehicle_numbers_patrol, 4] call _selectit, [d_vehicle_numbers_patrol,4] call _selectitvec]
];

_type_list_guard_static2 = [
	["stat_mg", 1, ceil (random 4)],
	["stat_gl", 1, ceil (random 3)]
];

_selectit = nil;
_selectitmen = nil;
_selectitvec = nil;

__TRACE_1("","_type_list_guard")

_trgobj = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_patrol_radius = _radius + 300 + random 300;

__TRACE_3("","_trgobj","_radius","_patrol_radius")

_trg_center = if (typeName _trgobj == "OBJECT") then {getPosATL _trgobj} else {_trgobj};
__TRACE_1("","_trg_center")
_wp_array = [_trg_center, _radius] call d_fnc_getwparray;
__TRACE_1("","_trg_center")
_wp_array_pat = [_trg_center, _patrol_radius] call d_fnc_getwparray;
__TRACE_2("","_wp_array","_wp_array_pat")

sleep 0.112;

{
	_nums = _x select 2;
	if (_nums > 0) then {
		for "_xxx" from 1 to _nums do {
			_wp_ran = (count _wp_array) call d_fnc_RandomFloor;
			[_x select 0, [_wp_array select _wp_ran], _trg_center, _x select 1, "guard", d_enemy_side, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
			_wp_array deleteAt _wp_ran;
			sleep 0.4;
		};
	};
} forEach _type_list_guard;

sleep 0.233;

{
	_nums = _x select 2;
	if (_nums > 0) then {
		for "_xxx" from 1 to _nums do {
			_wp_ran = (count _wp_array) call d_fnc_RandomFloor;
			[_x select 0, [_wp_array select _wp_ran], _trg_center, _x select 1, "guardstatic", d_enemy_side, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
			_wp_array deleteAt _wp_ran;
			sleep 0.4;
		};
	};
} forEach _type_list_guard_static;

{
	_nrgs = _x select 2;
	if (_nrgs > 0) then {
		for "_xxx" from 1 to _nrgs do {
			_point = [_trg_center, _radius] call d_fnc_GetRanPointCircleBig;
			_ccc = 0;
			while {count _point == 0 && {_ccc < 100}} do {
				_point = [_trg_center, _radius] call d_fnc_GetRanPointCircleBig;
				_ccc = _ccc + 1;
				sleep 0.01;
			};
			[_x select 0, [_point], _trg_center, _x select 1, "guardstatic2", d_enemy_side, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
			sleep 0.1;
		};
	};
} forEach _type_list_guard_static2;

d_del_mtd_objects = [];
d_ai_artiller_unit_vecs = [];

{
	_nums = _x select 2;
	if (_nums > 0) then {
		for "_xxx" from 1 to _nums do {
			_wp_ran = (count _wp_array_pat) call d_fnc_RandomFloor;
			[_x select 0, [_wp_array_pat select _wp_ran], _trg_center, _x select 1, (if ((_x select 0) == "basic" || {(_x select 0) == "specops"}) then {"patrol2mt"} else {"patrol"}), d_enemy_side, 0, -1.111, 1, [_trg_center, _patrol_radius]] call d_fnc_makegroup;
			_wp_array_pat deleteAt _wp_ran;
			sleep 0.4;
		};
	};
} forEach _type_list_patrol;

_type_list_guard = nil;
_type_list_guard_static = nil;
_type_list_guard_static2 = nil;
_type_list_patrol = nil;

sleep 2.124;

if (!d_no_more_observers) then {
	d_nr_observers = floor random 4;
	if (d_nr_observers < 2) then {d_nr_observers = 2};

	d_obs_array = [objNull, objNull, objNull];
	_unit_array = ["artiobserver", d_enemy_side] call d_fnc_getunitlist;
	for "_xx" from 0 to d_nr_observers - 1 do {
		_agrp = [d_side_enemy] call d_fnc_creategroup;
		_xx_ran = (count _wp_array) call d_fnc_RandomFloor;
		_xpos = _wp_array select _xx_ran;
		_wp_array deleteAt _xx_ran;
		_observer = ([_xpos, _unit_array select 0, _agrp] call d_fnc_makemgroup) select 0;
		[_agrp, _xpos, [_trg_center, _radius], [5, 20, 40]] spawn d_fnc_MakePatrolWPX;
		_agrp setVariable ["d_PATR", true];
		_observer addEventHandler ["killed", {d_nr_observers = d_nr_observers - 1;
			if (d_nr_observers == 0) then {
				["d_kbmsg", [3]] call d_fnc_NetCallEventCTS;
			};
			(_this select 0) removeAllEventHandlers "killed";
		}];
		d_obs_array set [_xx, _observer];
		sleep 0.4;
	};
	_unit_array = nil;

	["d_kbmsg", [6, d_nr_observers]] call d_fnc_NetCallEventCTS;
	0 spawn d_fnc_handleobservers;
	sleep 1.214;
};

[_wp_array, d_target_radius, _trg_center] spawn d_fnc_createsecondary;

execFSM "fsms\RespawnGroups.fsm";

_wp_array_pat = nil;
