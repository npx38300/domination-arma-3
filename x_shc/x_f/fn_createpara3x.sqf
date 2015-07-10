// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createpara3x.sqf"
#include "x_setup.sqf"
private ["_startpoint","_attackpoint","_heliendpoint","_number_vehicles","_make_jump","_stop_it","_cur_tgt_pos","_dummy","_delveccrew"];
if !(call d_fnc_checkSHC) exitWith {};

_startpoint = [_this, 0] call BIS_fnc_param;
_attackpoint = [_this, 1] call BIS_fnc_param;
_heliendpoint = [_this, 2] call BIS_fnc_param;
_number_vehicles = [_this, 3] call BIS_fnc_param;
__TRACE_3("","_startpoint","_attackpoint","_heliendpoint")
__TRACE_1("","_number_vehicles")

d_should_be_there = _number_vehicles;

d_c_attacking_grps = [];

_delveccrew = {
	scriptName "spawn_x_createpara3_delveccrew";
	private ["_crew_vec", "_vehicle", "_time"];
	_crew_vec = [_this, 0] call BIS_fnc_param;
	_vehicle = [_this, 1] call BIS_fnc_param;
	_time = [_this, 2] call BIS_fnc_param;
	sleep _time;
	{if (!isNull _x) then {_x setDamage 1}} forEach _crew_vec;
	sleep 1;
	if (!isNull _vehicle && {({isPlayer _x} count (crew _vehicle)) == 0}) then {_vehicle setDamage 1};
};

_make_jump = {
	scriptName "spawn_x_createpara3_make_jump";
	private ["_vgrp", "_vehicle", "_attackpoint", "_heliendpoint", "_driver_vec", "_wp", "_stop_me", "_dummy", "_cur_tgt_pos", "_paragrp", "_unit_array", "_real_units", "_i", "_one_unit", "_para", "_grp_array","_crew_vec","_delveccrew"];
	_vgrp = [_this, 0] call BIS_fnc_param;
	_vehicle = [_this, 1] call BIS_fnc_param;
	_attackpoint = [_this, 2] call BIS_fnc_param;
	_heliendpoint = [_this, 3] call BIS_fnc_param;
	_delveccrew = [_this, 4] call BIS_fnc_param;
	
	__TRACE("_make_jump")
	
	_startpos = getPosATL _vehicle;
	_driver_vec = driver _vehicle;
	_crew_vec = crew _vehicle;
	
	_wp = _vgrp addWaypoint [_attackpoint, 0];
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointtype "MOVE";
	_wp setWaypointFormation "VEE";
	_wp = _vgrp addWaypoint [_heliendpoint, 0];
	
	_vehicle flyInHeight 100;
	
	sleep 10.0231;
	
	_stop_me = false;
	_checktime = time + 300;
	while {[_attackpoint select 0, _attackpoint select 1, 0] distance [getPosASL (leader _vgrp) select 0, getPosASL (leader _vgrp) select 1, 0] > 300} do {
		if (isNull _vehicle || {!alive _vehicle} || {!alive _driver_vec} || {!canMove _vehicle}) exitWith {d_should_be_there = d_should_be_there - 1};
		sleep 0.01;
		if (d_mt_radio_down && {(_attackpoint distance (leader _vgrp) > 1300)}) exitWith {
			[_crew_vec, _vehicle, 1 + random 1] spawn _delveccrew;
			_stop_me = true;
		};
		sleep 0.01;
		if (time > _checktime) then {
			if (_startpos distance _vehicle < 500) then {
				d_should_be_there = d_should_be_there - 1;
				[_crew_vec, _vehicle, 1 + random 1] spawn _delveccrew;
				_stop_me = true;
			} else {
				_checktime = time + 9999999;
			};
		};
		if (_stop_me) exitWith {};
		sleep 2.023;
	};
	if (_stop_me) exitWith {};
	
	sleep 0.534;
	
	if (!isNull _vehicle && {alive _vehicle} && {alive _driver_vec} && {canMove _vehicle}) then {
		_dummy = d_target_names select d_current_target_index;
		_cur_tgt_pos = _dummy select 0;
		if (!d_mt_radio_down && {(_vehicle distance _cur_tgt_pos < 500)}) then {
			_cur_radius = _dummy select 2;
			_paragrp = [d_side_enemy] call d_fnc_creategroup;
			_unit_array = ["heli", d_enemy_side] call d_fnc_getunitlist;
			_real_units = _unit_array select 0;
			_unit_array = nil;
			sleep 0.1;
			{
				_pposcx = getPosATL _vehicle;
				_one_unit = _paragrp createUnit [_x, [_pposcx select 0, _pposcx select 1, 0], [], 0,"NONE"];
				_para = createVehicle [d_non_steer_para, _pposcx, [], 20, 'NONE'];
				_one_unit moveInDriver _para;
				_para setDir random 360;
				_pposcx = getPosATL _vehicle;
				_para setPos [_pposcx select 0, _pposcx select 1, (_pposcx select 2) - 10];
				_one_unit call d_fnc_removeNVGoggles;
				_one_unit call d_fnc_removefak;
				if (d_with_ai && {d_with_ranked}) then {
					_one_unit addEventHandler ["MPKilled", {if (isServer) then {[1, _this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllEventHandlers "MPKilled"}}];
				};
				_one_unit setSkill ((d_skill_array select 0) + (random (d_skill_array select 1)));
				sleep 0.551;
			} forEach _real_units;
			_paragrp allowFleeing 0;
			_paragrp setCombatMode "YELLOW";
			_paragrp setBehaviour "AWARE";
			 [_paragrp, 1] call d_fnc_setGState;
			
			[_paragrp, _cur_tgt_pos, _cur_radius] spawn {
				scriptName "spawn_x_createpara3_usegroup";
				private ["_grp", "_pos"];
				_grp = [_this, 0] call BIS_fnc_param;
				_pos = [_this, 1] call BIS_fnc_param;
				sleep 30;
				if ((_grp call d_fnc_GetAliveUnitsGrp) > 0) then {
					[_grp, _pos, [_pos, [_this, 2] call BIS_fnc_param], [10, 20, 50], ""] spawn d_fnc_MakePatrolWPX;
					_grp setVariable ["d_PATR",true];
				};
			};
			
			d_c_attacking_grps pushBack _paragrp;
			
			sleep 0.112;
			d_should_be_there = d_should_be_there - 1;
			
			while {(_heliendpoint distance (leader _vgrp) > 300)} do {
				if (isNull _vehicle || {!alive _vehicle} || {!alive _driver_vec} || {!canMove _vehicle}) exitWith {};
				sleep 5.123;
			};
			
			if (!isNull _vehicle && {(_heliendpoint distance _vehicle) > 300}) then {
				[_crew_vec, _vehicle, 240 + random 100] spawn _delveccrew;
			} else {
				_vehicle call d_fnc_DelVecAndCrew;
			};
			if (!isNull _driver_vec) then {_driver_vec setDamage 1.1};
		};
	} else {
		[_crew_vec, _vehicle, 240 + random 100] spawn _delveccrew;
	};
};

_cur_tgt_pos = (d_target_names select d_current_target_index) select 0;
_stop_it = false;

if (d_searchintel select 0 == 1) then {
	["d_kbmsg", [43]] call d_fnc_NetCallEventCTS;
};

for "_i" from 1 to _number_vehicles do {
	if (d_mt_radio_down) exitWith {_stop_it = true};
	if (((d_target_names select d_current_target_index) select 0) distance _cur_tgt_pos > 500) exitWith {_stop_it = true};
	_vgrp = [d_side_enemy] call d_fnc_creategroup;
	_heli_type = d_transport_chopper call d_fnc_RandomArrayVal;
	_spos = [_startpoint select 0, _startpoint select 1, 300];
	_vehicle = ([_spos, [_spos, _attackpoint] call d_fnc_DirTo, _heli_type, _vgrp] call d_fnc_spawnVehicle) select 0;
	if !((toUpper _heli_type) in d_heli_wreck_lift_types) then {
		d_allunits_add pushBack _vehicle;
	} else {
		_vehicle setVariable ["d_iswlt", true];
	};
	_vehicle spawn d_fnc_AirMarkerMove;
	_vehicle addEventHandler ["HandleDamage", {if ((_this select 4) isKindOf "MissileCore") then {1;} else {_this select 2;};}];
	if (d_with_ai && {d_with_ranked}) then {
		_vehicle addMPEventHandler ["MPkilled", {if (isServer) then {[8,_this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllMPEventHandlers "MPKilled"}}];
	};

	if (d_LockAir == 0) then {_vehicle lock true};
	sleep 5.012;
	
	_vehicle flyInHeight 100;

	if (d_mt_radio_down) exitWith {_stop_it = true};
	
	[_vgrp,_vehicle,_attackpoint,_heliendpoint, _delveccrew] spawn _make_jump;
	
	sleep 30 + random 30;
};

if (_stop_it) exitWith {};

while {d_should_be_there > 0 && {!d_mt_radio_down}} do {sleep 1.021};

if (!d_mt_radio_down) then {
	sleep 20.0123;
	if !(d_c_attacking_grps isEqualTo []) then {
		[d_c_attacking_grps] spawn d_fnc_handleattackgroups;
	} else {
		d_c_attacking_grps = [];
		d_create_new_paras = true;
	};
};