// by Xeno
#define THIS_FILE "fn_getsidemission.sqf"
#include "x_setup.sqf"
private ["_missionfile", "_cur_sm_idx"];
if (!isServer) exitWith{};

if (d_all_sm_res) exitWith {};

if (d_current_mission_counter == d_number_side_missions) exitWith {
	d_all_sm_res = true; publicVariable "d_all_sm_res";
	["all_sm_res"] call d_fnc_NetCallEvent;
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"AllSMissionsResolved","SIDE"];
	["itemRemove", ["DOM_SM_RES_ID"]] call BIS_fnc_loop;
};

#ifndef __SMDEBUG__
if (d_MissionType != 2) then {
	while {!d_main_target_ready} do {sleep 2.321};
};
#endif

_cur_sm_idx = d_side_missions_random select d_current_mission_counter;
d_current_mission_counter = d_current_mission_counter + 1;

d_x_sm_rem_ar = [];
d_x_sm_vec_rem_ar = [];

//_cur_sm_idx = _this select 0;
//_cur_sm_idx = 50;

_missionfile = format ["x_missions\ma3a\%2%1.sqf", _cur_sm_idx, d_sm_fname];

if (isNil "d_HC_CLIENT_OBJ") then {
	execVM _missionfile;
	sleep 7.012;
	["d_s_sm_up", [_cur_sm_idx, d_x_sm_pos, d_x_sm_type]] call d_fnc_NetCallEventCTS;
} else {
	["d_hcexecsm", [d_HC_CLIENT_OBJ, _missionfile, _cur_sm_idx]] call d_fnc_NetCallEventSTO;
};
