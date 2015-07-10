// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_setuphc.sqf"
#include "x_setup.sqf"

__TRACE("Running HC setup")

player removeAllEventHandlers "handleDamage";
player removeAllEventHandlers "respawn";
player addEventHandler ["handleDamage", {0}];
player setPos [-10000,10000,0.3];
["d_e_s_g", [player, false]] call d_fnc_NetCallEventCTS;
["d_h_o_g", player] call d_fnc_NetCallEventCTS;
enableEnvironment false;
player addEventHandler ["respawn", {
	player setFatigue 0;
	player enableFatigue false;
	player setPos [-10000,10000,0.3];
	player removeAllEventHandlers "handleDamage";
	player addEventHandler ["handleDamage", {0}];
	player allowDamage false;
	["d_h_o_g", player] call d_fnc_NetCallEventCTS;
	["d_e_s_g", [player, false]] call d_fnc_NetCallEventCTS;
	["d_nHCObj", player] call d_fnc_NetCallEventCTS;
}];

call compile preprocessFileLineNumbers "x_shc\x_shcinit.sqf";

_confmapsize = getNumber(configFile/"CfgWorlds"/worldName/"mapSize");
d_island_center = [_confmapsize / 2, _confmapsize / 2, 300];

d_island_x_max = _confmapsize;
d_island_y_max = _confmapsize;

["d_docnt", {_this spawn d_fnc_docreatenexttarget}] call d_fnc_NetAddEventSTO;
["d_docountera", {0 spawn d_fnc_counterattack}] call d_fnc_NetAddEventSTO;
["d_dodel1", {
	(_this select 1) execFSM "fsms\DeleteUnits.fsm";
	if (!isNil "d_mines_created" && {!(d_mines_created isEqualTo [])}) then {
		{
			deleteVehicle _x;
		} forEach d_mines_created;
		d_mines_created = [];
	};
}] call d_fnc_NetAddEventSTO;
["d_dodel2", {
	d_del_camps_stuff = (_this select 1) select 2;
	(_this select 1) execFSM "fsms\DeleteEmpty.fsm"}
] call d_fnc_NetAddEventSTO;
["d_hcexecsm", {
	d_x_sm_rem_ar = [];
	d_x_sm_vec_rem_ar = [];
	d_sm_resolved = false;
	d_sm_winner = 0;
	execVM (_this select 1);
	(_this select 2) spawn {
		sleep 7.012;
		["d_s_sm_up", [_this, d_x_sm_pos, d_x_sm_type]] call d_fnc_NetCallEventCTS;
	};
}] call d_fnc_NetAddEventSTO;

["d_dodelintelu", {
	if (!isNull d_intel_unit) then {
		deleteVehicle d_intel_unit;
		d_intel_unit = objNull;
	};
}] call d_fnc_NetAddEventSTO;

["d_dodelrspgrps", {
	if !(d_respawn_ai_groups isEqualTo []) then {
		0 spawn {
			scriptName "spawn_respawn_ai_groups";
			__TRACE_1("","d_respawn_ai_groups")
			{
				if (typeName _x == "ARRAY") then {
					private "_rgrp";
					_rgrp = _x select 0;
					__TRACE_1("","_rgrp")
					if (!isNil "_rgrp" && {typeName _rgrp == "GROUP"} && {!isNull _rgrp}) then {
						{
							private "_uni";
							_uni = _x;
							__TRACE_1("","_uni")
							if (!isNil "_uni" && {!isNull _uni}) then {
								private "_v";
								_v = vehicle _uni;
								__TRACE_1("","_v")
								if (_v != _uni && {alive _v}) then {_v setDamage 1};
								if (alive _uni) then {_uni setDamage 1}
							};
						} forEach (units _rgrp);
					};
				};
			} forEach d_respawn_ai_groups;
		};
	};
}] call d_fnc_NetAddEventSTO;

["d_hSetVar", {missionNamespace setVariable [_this select 1, _this select 2]}] call d_fnc_NetAddEventSTO;
["d_smclear", {execFSM "fsms\XClearSidemission.fsm"}] call d_fnc_NetAddEventSTO;
["d_mct", {
	d_current_trigger = (_this select 1) call d_fnc_CreateTrigger;
}] call d_fnc_NetAddEventSTO;
["d_xdelct", {deleteVehicle d_current_trigger}] call d_fnc_NetAddEventSTO;

["d_hcready"] call d_fnc_NetCallEventCTS;
