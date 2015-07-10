// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_airai.sqf"
#include "x_setup.sqf"
private ["_type", "_pos", "_wp_behave", "_heli_type", "_vehicle", "_grp", "_vehicles", "_funits", "_unit", "_num_p", "_re_random", "_grpskill", "_numair", "_vec_array", "_loop_do", "_dummy", "_cur_tgt_pos", "_wp", "_radius", "_vehicles_number", "_old_target", "_old_pat_pos"];
if !(call d_fnc_checkSHC) exitWith {};

__TRACE("airai")

_type = [_this, 0] call BIS_fnc_param;

_wp_behave = "AWARE";

while {true} do {
#ifndef __DEBUG__
	if (!d_mt_radio_down) then {
		while {!d_mt_spotted} do {sleep 11.32};
	} else {
		while {d_mt_radio_down} do {sleep 10.123};
		if (!d_mt_spotted) then {
			while {!d_mt_spotted} do {sleep 12.32};
		};
	};
#endif
	_grp = objNull;
	_vehicle = objNull;
	_vehicles = [];
	_funits = [];
	_unit = objNull;
	_num_p = call d_fnc_PlayersNumber;
#ifndef __DEBUG__
	sleep (switch (true) do {
		case (_num_p < 5): {500};
		case (_num_p < 10): {300};
		case (_num_p < 20): {100};
		default {0};
	});
#endif
	call d_fnc_mpcheck;
	while {d_mt_radio_down} do {sleep 6.123};
	_pos = call d_fnc_GetRanPointOuterAir;
	
	_grpskill = 0.6 + (random 0.3);
	__TRACE_2("","_pos","_grpskill")

	_grp = [d_side_enemy] call d_fnc_creategroup;
	__TRACE_1("","_grp")
	_heli_type = "";
	_numair = 0;
	switch (_type) do {
		case "KA": {
			_heli_type = d_airai_attack_chopper call d_fnc_RandomArrayVal;
			_numair = d_number_attack_choppers;
		};
		case "SU": {
			_heli_type = d_airai_attack_plane call d_fnc_RandomArrayVal;
			_numair = d_number_attack_planes;
		};
		case "MIMG": {
			_heli_type = d_light_attack_chopper call d_fnc_RandomArrayVal;
			_numair = d_number_attack_choppers;
		};
	};
	
	__TRACE_2("","_heli_type","_numair")
	
	waitUntil {sleep 0.323; d_current_target_index >= 0};
	_cdir = [_pos, d_island_center] call d_fnc_DirTo;
	switch (_type) do {
		case "SU": {if (d_searchintel select 1 == 1) then {["d_kbmsg", [0]] call d_fnc_NetCallEventCTS}};
		case "KA": {if (d_searchintel select 2 == 1) then {["d_kbmsg", [1]] call d_fnc_NetCallEventCTS}};
		case "MIMG": {if (d_searchintel select 3 == 1) then {["d_kbmsg", [2]] call d_fnc_NetCallEventCTS}};
	};
	for "_xxx" from 1 to _numair do {
		_vec_array = [[_pos select 0, _pos select 1, 400], _cdir, _heli_type, _grp] call d_fnc_spawnVehicle;
		__TRACE_1("","_vec_array")
		
		_vehicle = _vec_array select 0;
		_vehicle setPos [_pos select 0, _pos select 1, 400];
		_vehicles pushBack _vehicle;
		__TRACE_1("","_vehicles")
		
		_funits = [_funits, _vec_array select 1] call d_fnc_arrayPushStack;
		__TRACE_1("","_funits")
				
		[_vehicle] call d_fnc_addToClean;
		_vehicle flyInHeight 100;
		_vehicle addEventHandler ["HandleDamage", {if ((_this select 4) isKindOf "MissileCore") then {1;} else {_this select 2;};}];

		_vehicle spawn d_fnc_AirMarkerMove;
		__TRACE_1("","_vehicle")
		sleep 0.1;
	};
	
	(leader _grp) setSkill _grpskill;
	
	sleep 1.011;
	
	_grp allowFleeing 0;
	
	waitUntil {sleep 0.323; d_current_target_index >= 0};
	_old_target = [0,0,0];
	_loop_do = true;
	_dummy = d_target_names select d_current_target_index;
	_cur_tgt_pos = _dummy select 0;
	_cur_tgt_pos set [2, 0];
	_wp = _grp addWayPoint [_cur_tgt_pos, 0];
	_wp setWaypointType "SAD";
	_pat_pos = _cur_tgt_pos;
	[_grp, 1] setWaypointStatements ["never", ""];
	while {_loop_do} do {
		waitUntil {sleep 0.323; d_current_target_index >= 0};
		_dummy = d_target_names select d_current_target_index;
		_cur_tgt_pos = _dummy select 0;
		_cur_tgt_pos set [2, 0];
		_radius = _dummy select 2;
		
		sleep 3 + random 2;
		
		_radius = switch (_type) do {
			case "KA": {_radius * 3};
			case "MIMG": {_radius * 3};
			case "SU": {_radius * 5};
			default {_radius};
		};
		
		__TRACE_1("","_radius")
		
#define __patternpos \
_angle = floor (random 360);\
_pat_pos = [(_cur_tgt_pos select 0) - ((random _radius) * sin _angle), (_cur_tgt_pos select 1) - ((random _radius) * cos _angle), _cur_tgt_pos select 2]

#ifdef __DEBUG__
	_xdist = (_vehicles select 0) distance _cur_tgt_pos;
	__TRACE_1("","_xdist")
#endif
		_curvec = objNull;
		{
			if (alive _x && {canMove _x}) exitWith {
				_curvec = _x;
			};
		} forEach _vehicles;
		if (!isNull _curvec && {_curvec distance _cur_tgt_pos < _radius}) then {
			if (_type == "KA" || {_type == "MIMG"}) then {
				_old_pat_pos = _pat_pos;
				__patternpos;
				while {_pat_pos distance _old_pat_pos < 100} do {
					__patternpos;
					sleep 0.01;
				};
				_pat_pos = _pat_pos call d_fnc_WorldBoundsCheck;
				[_grp, 1] setWaypointPosition [_pat_pos, 0];
				_grp setSpeedMode "NORMAL";
				_grp setBehaviour _wp_behave;
				sleep 45.821 + random 15;
			} else {
				__patternpos;
				_pat_pos = _pat_pos call d_fnc_WorldBoundsCheck;
				[_grp, 1] setWaypointPosition [_pat_pos, 0];
				_grp setSpeedMode "LIMITED";
				_grp setBehaviour _wp_behave;
				sleep 120 + random 120;
			};
			{
				if (alive _x) then {
					_x flyInHeight 100;
				};
			} forEach _vehicles;
		};

		__TRACE("call mpcheck")
		call d_fnc_mpcheck;
		
		sleep 30;

		if !(_vehicles isEqualTo []) then {
			__TRACE("_vehicles array not empty")
			{
				if (isNull _x || {!alive _x} || {!canMove _x}) then {
					__TRACE_1("not alive","_x")
					if (!canMove _x) then {
						_x spawn {
							__TRACE("deleting airai vehicle")
							scriptName "spawn_x_airai_delvec1";
							private "_vec";
							_vec = _this;
							sleep 200;
							if (alive _vec && {canMove _vec}) exitWith {};
							if (!isNull _vec) then {_vec call d_fnc_DelVecAndCrew};
						};
					};
					_vehicles set [_forEachIndex, -1];
				} else {
					_x setFuel 1;
				};
			} forEach _vehicles;
			_vehicles = _vehicles - [-1];
		};
		if (_vehicles isEqualTo []) then {
			__TRACE("_vehicles array IS empty")
			{if (!isNull _x) then {deleteVehicle _x}} forEach _funits;
			_funits = [];
			_vehicles = [];
			_loop_do = false;
		};
	};
	#ifndef __DEBUG__
	_num_p = call d_fnc_PlayersNumber;
	_re_random = switch (true) do {
		case (_num_p < 5): {850};
		case (_num_p < 10): {600};
		case (_num_p < 20): {350};
		default {100};
	};
	sleep (d_airai_respawntime + _re_random + random (_re_random));
	#else
	sleep 10;
	#endif
};
