// by Xeno
#define THIS_FILE "fn_counterattack.sqf"
#include "x_setup.sqf"
private ["_dummy", "_numbervecs", "_xx", "_typeidx", "_nums", "_i"];
if !(call d_fnc_checkSHC) exitWith {};

if (isServer && {!isNil "d_HC_CLIENT_OBJ"}) exitWith {
	["d_docountera", d_HC_CLIENT_OBJ] call d_fnc_NetCallEventSTO;
};

_dummy = d_target_names select d_current_target_index;
_cur_tgt_pos = _dummy select 0;

_start_array = [_cur_tgt_pos, (_dummy select 2) + 200] call d_fnc_getwparray2;

_vecs_counter_attack = 5 call d_fnc_RandomFloor;
if (_vecs_counter_attack < 2) then {_vecs_counter_attack = 2};
_numbervecs = _vecs_counter_attack - 2;
if (_numbervecs <= 0) then {_numbervecs = 1};

_type_list_attack = [
	["basic",0,ceil (random _vecs_counter_attack)],
	["specops",0,ceil (random _vecs_counter_attack)],
	["tank",(ceil random _numbervecs),ceil (random (_vecs_counter_attack - 1))],
	["tracked_apc",(ceil random _numbervecs),ceil (random (_vecs_counter_attack - 1))]
];

sleep 120 + random 120;

["d_kbmsg", [20]] call d_fnc_NetCallEventCTS;

for "_xx" from 0 to (count _type_list_attack - 1) do {
	_typeidx = _type_list_attack select _xx;
	_nums = _typeidx select 2;
	if (_nums > 0) then {
		for "_i" from 1 to _nums do {
			[_typeidx select 0, _start_array, _cur_tgt_pos, _typeidx select 1, "attack", d_enemy_side, 0, -1.111] call d_fnc_makegroup;
			sleep 5.123;
		};
	};
};

_start_array = nil;
_type_list_attack = nil;

_cur_tgt_pos spawn {
	scriptName "spawn_counterattack_trig";
	sleep 301.122;
	d_current_trigger = [_this, [350, 350, 0, false], [d_enemy_side_trigger, "PRESENT", false], ["(""Tank"" countType thislist  < 2) && {(""CAManBase"" countType thislist < 6)}", "d_counterattack = false;if (d_IS_HC_CLIENT) then {['d_sSetVar', ['d_counterattack', false]] call d_fnc_NetCallEventCTS};deleteVehicle d_current_trigger", ""]] call d_fnc_CreateTrigger;
};
