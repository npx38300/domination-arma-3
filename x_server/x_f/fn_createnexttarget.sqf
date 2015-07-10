// by Xeno
//#define __DEBUG__
#include "x_setup.sqf"
#define THIS_FILE "fn_createnexttarget.sqf"
private ["_cur_tgt_pos","_cur_tgt_radius","_dummy","_emptyH","_cur_tgt_name"];
if (!isServer) exitWith{};

sleep 1;

__TRACE("start")

d_current_target_index = d_maintargets_list select d_current_counter;
publicVariable "d_current_target_index";
d_current_counter = d_current_counter + 1;

__TRACE_2("","d_current_target_index","d_current_counter")

sleep 1.0123;
if (d_first_time_after_start) then {
	d_first_time_after_start = false;
	sleep 18.123;
};

d_update_target = false;
d_main_target_ready = false;
d_side_main_done = false;
d_sum_camps = -91;

_dummy = d_target_names select d_current_target_index;
_cur_tgt_pos = _dummy select 0;
_cur_tgt_name = _dummy select 1;
_cur_tgt_radius = _dummy select 2;

__TRACE_1("","_dummy")
d_mt_loc = _cur_tgt_pos;
d_target_radius = _cur_tgt_radius;
d_mttarget_radius_patrol = _cur_tgt_radius + 200 + random 200;

_tsar = if (d_WithLessArmor == 0) then {
	["('Man' countType thislist >= d_man_count_for_target_clear) && {('Tank' countType thislist >= d_tank_count_for_target_clear)} && {('Car' countType thislist  >= d_car_count_for_target_clear)}", "d_target_clear = false; publicVariable 'd_target_clear';d_update_target=true;call d_fnc_makemtgmarker;['d_update_target'] call d_fnc_NetCallEventToClients;d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,'Attack',['1','','" + _cur_tgt_name + "',['" + _cur_tgt_name + "']],'SIDE'];deleteVehicle d_check_trigger", ""]
} else {
	["('Man' countType thislist >= d_man_count_for_target_clear)", "d_target_clear = false; publicVariable 'd_target_clear';d_update_target=true;call d_fnc_makemtgmarker;['d_update_target'] call d_fnc_NetCallEventToClients;d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,'Attack',['1','','" + _cur_tgt_name + "',['" + _cur_tgt_name + "']],'SIDE'];deleteVehicle d_check_trigger;", ""]
};

d_check_trigger = [_cur_tgt_pos, [_cur_tgt_radius + 200, _cur_tgt_radius + 200, 0, false], [d_enemy_side_trigger, "PRESENT", false], _tsar] call d_fnc_CreateTrigger;

d_house_objects = nearestObjects [_cur_tgt_pos, ["house"], 700];

[_cur_tgt_pos, _cur_tgt_radius] spawn d_fnc_docreatenexttarget;

while {!d_update_target} do {sleep 2.123};

_tsar = ["d_mt_radio_down && {d_side_main_done} && {d_campscaptured == d_sum_camps} && {('Car' countType thislist <= d_car_count_for_target_clear)} && {('Tank' countType thislist <= d_tank_count_for_target_clear)} && {('Man' countType thislist <= d_man_count_for_target_clear)}", "0 = 0 spawn d_fnc_target_clear", ""];
__TRACE_1("","_tsar")
d_current_trigger = [_cur_tgt_pos, [_cur_tgt_radius  + 50, _cur_tgt_radius + 50, 0, false],[d_enemy_side_trigger, "PRESENT", false], _tsar] call d_fnc_CreateTrigger;
__TRACE_1("","d_current_trigger")
if (!isNil "d_HC_CLIENT_OBJ") then {
	["d_mct", [d_HC_CLIENT_OBJ, [_cur_tgt_pos, [_cur_tgt_radius  + 50, _cur_tgt_radius + 50, 0, false],[d_enemy_side_trigger, "PRESENT", false], ["this","",""]]]] call d_fnc_NetCallEventSTO;
};
