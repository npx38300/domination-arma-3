// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_shcinit.sqf"
#include "x_setup.sqf"

__TRACE("x_shcinit")

if !(call d_fnc_checkSHC) exitWith {};

d_allunits_add = [];
d_allunits_ai_add = [];
d_delvecsmt = [];
d_no_more_observers = false;
d_counterattack = false;
d_create_new_paras = false;
d_x_sm_rem_ar = [];
d_x_sm_vec_rem_ar = [];
d_check_trigger = objNull;
d_first_time_after_start = true;
d_nr_observers = 0;
d_sm_resolved = false;
d_main_target_ready = false;
d_mt_spotted = false;
d_mt_radio_down = false;

if (d_IS_HC_CLIENT) then {
	call compile preprocessFileLineNumbers "x_shc\x_f\x_shcfunctions.sqf";
	call compile preprocessFileLineNumbers "i_server.sqf";
};

execFSM "fsms\NotAliveRemover.fsm";
if (isServer) then {
	execFSM "fsms\NotAliveRemoverUnits.fsm";
};
execFSM "fsms\GroupClean.fsm";

if (d_IS_HC_CLIENT) then {
	["d_cgraa", {
		private ["_side", "_vect"];
		_side = [_this, 0] call BIS_fnc_param;
		_vect = [_this, 1] call BIS_fnc_param;
		for "_io" from 1 to 2 do {
			_mmm = format ["d_base_anti_air%1", _io];
			_ret = [1, markerPos _mmm, _vect, [_side] call d_fnc_creategroup, markerDir _mmm] call d_fnc_makevgroup;
			((_ret select 0) select 0) lock true;
		};
	}] call d_fnc_NetAddEventSTO;
};

if (d_WithRecapture == 0 && {d_MissionType != 2}) then {execFSM "fsms\Recapture.fsm"};

// start air AI after some time
if (d_MissionType != 2) then {
	0 spawn {
		scriptName "spawn_x_shcinit_airai";
		sleep 30;
		if (isServer && {!isNil "d_HC_CLIENT_OBJ"}) exitWith {};
		sleep 880;
		["MIMG"] execVM "x_shc\x_airai.sqf";
		sleep 880;
		["KA"] execVM "x_shc\x_airai.sqf";
		sleep 801.123;
		["SU"] execVM "x_shc\x_airai.sqf";
	};
};

if !(d_with_isledefense isEqualTo []) then {execVM "x_shc\x_isledefense.sqf"};