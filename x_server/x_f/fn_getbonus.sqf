// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getbonus.sqf"
#include "x_setup.sqf"
private ["_chance", "_btype", "_vec_type", "_vecclass", "_vehicle", "_endpos", "_dir", "_airval", "_bonus_number"];

__TRACE("Before !isServer")

if (!isServer) exitWith {};

__TRACE("Starting")

if (d_MissionType == 2) exitWith {
	["d_sm_res_client", [d_sm_winner, ""]] call d_fnc_NetCallEventToClients;
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MissionAccomplished","SIDE"];

	if !(isServer && {!isDedicated}) then {d_sm_winner = 0};
};

_vec_type = "";
if (d_current_sm_bonus_vec == "") then {
	_airval = 72;
	_chance = 0;

	if (d_land_bonus_vecs == 0) then {
		_chance = _airval + 1;
	} else {
		if (d_air_bonus_vecs == 0) then {
			_chance = 0;
		} else {
			if (d_air_bonus_vecs > d_land_bonus_vecs) then {
				_airval = floor ((d_land_bonus_vecs / d_air_bonus_vecs) * 100);
			};
			_chance = floor (random 100);
		};
	};
	
	__TRACE_1("","_chance")

	_btype = "";

	__TRACE_2("","d_land_bonus_vecs","d_air_bonus_vecs")
	while {_btype == ""} do {
		_bonus_number = d_sm_bonus_vehicle_array call d_fnc_RandomFloorArray;
		_vec_type = d_sm_bonus_vehicle_array select _bonus_number;
		__TRACE_2("","_bonus_number","_vec_type")
		if (count d_sm_bonus_vehicle_array > 3 && {d_land_bonus_vecs > 2} && {d_air_bonus_vecs > 2}) then {
		_vecclass = getText(configFile/"CfgVehicles"/_vec_type/"vehicleClass");
		__TRACE_1("","_bonus_number","_vecclass")
			if (_chance > _airval) then {
				if (_vecclass == "Air" && {d_last_bonus_vec != _vec_type}) then {_btype = _vec_type};
			} else {
				if (_vecclass != "Air" && {d_last_bonus_vec != _vec_type}) then {_btype = _vec_type};
			};
		} else {
			_btype = _vec_type;
		};
		sleep 0.01;
	};
} else {
	_vec_type = d_current_sm_bonus_vec;
	d_current_sm_bonus_vec = "";
};

__TRACE_1("","_vec_type")

d_last_bonus_vec = _vec_type;
//_vec_type = d_sm_bonus_vehicle_array select _bonus_number;

sleep 1.012;

_vehicle = createVehicle [_vec_type, d_bonus_create_pos, [], 0, "NONE"];
/*if (getNumber(configFile/"CfgVehicles"/_vec_type/"isUav") == 0) then {
	_vehicle setVehicleAmmo 0;
	_vehicle setFuel 0.1;
} else {
	createVehicleCrew _vehicle;
};*/
if (getNumber(configFile/"CfgVehicles"/_vec_type/"isUav") != 0) then {
	createVehicleCrew _vehicle;
};
_endpos = [];
_dir = 0;
__TRACE_1("","_vehicle")

if (_vehicle isKindOf "Air") then {
	_endpos = (d_bonus_air_positions select d_bap_counter) select 0;
	_dir = (d_bonus_air_positions select d_bap_counter) select 1;
	d_bap_counter = d_bap_counter + 1;
	if (d_bap_counter > (count d_bonus_air_positions - 1)) then {d_bap_counter = 0};
} else {
	_endpos = (d_bonus_vec_positions select d_bvp_counter) select 0;
	_dir = (d_bonus_vec_positions select d_bvp_counter) select 1;
	d_bvp_counter = d_bvp_counter + 1;
	if (d_bvp_counter > (count d_bonus_vec_positions - 1)) then {d_bvp_counter = 0};
};

_vehicle setDir _dir;
_vehicle setPos _endpos;

_vehicle addMPEventHandler ["MPKilled", {if (isServer) then {(_this select 0) execFSM "fsms\Wreckmarker.fsm";(_this select 0) removeAllMPEventHandlers "MPKilled"}}];

__TRACE_1("","d_sm_winner")
["d_sm_res_client", [d_sm_winner,_vec_type]] call d_fnc_NetCallEventToClients;
d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MissionAccomplished","SIDE"];

if !(isServer && {!isDedicated}) then {d_sm_winner = 0};