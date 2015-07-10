// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_target_clear.sqf"
#include "x_setup.sqf"
private ["_cur_tgt_name","_start_real"];
if (!isServer) exitWith{};

sleep 1.123;

if (!isNull d_f_check_trigger) then {deleteVehicle d_f_check_trigger};
deleteVehicle d_current_trigger;
if (!isNil "d_HC_CLIENT_OBJ") then {
	["d_xdelct", d_HC_CLIENT_OBJ] call d_fnc_NetCallEventSTO;
};
sleep 0.01;

_cur_tgt_name = (d_target_names select d_current_target_index) select 1;

d_counterattack = false;
_start_real = false;
if ((random 100) > 95) then {
	d_counterattack = true;
	_start_real = true;	
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"CounterattackEnemy",["1","",_cur_tgt_name,[]],"SIDE"];
	0 spawn d_fnc_counterattack;
};

while {d_counterattack} do {sleep 3.123};

if (_start_real) then {
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"CounterattackDefeated","SIDE"];
	sleep 2.321;
};

d_old_target_pos =+ ((d_target_names select d_current_target_index) select 0);
d_old_radius = [(d_target_names select d_current_target_index) select 2];

d_resolved_targets pushBack d_current_target_index;
publicVariable "d_resolved_targets";

if (!isNil "d_HC_CLIENT_OBJ") then {
	["d_dodelintelu", d_HC_CLIENT_OBJ] call d_fnc_NetCallEventSTO;
} else {
	if (!isNull d_intel_unit) then {
		deleteVehicle d_intel_unit;
		d_intel_unit = objNull;
	};
};

sleep 0.5;

if (d_current_counter < d_MainTargets) then {
	0 spawn d_fnc_gettargetbonus;
} else {
	d_target_clear = true; publicVariable "d_target_clear";
	["d_s_mc_g", ["d_" + _cur_tgt_name + "_dommtm", "ColorGreen"]] call d_fnc_NetCallEventCTS;
	["d_target_clear", ""] call d_fnc_NetCallEventToClients;
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Captured2",["1","",_cur_tgt_name,[_cur_tgt_name]],"SIDE"];
};

sleep 2.123;

if (!isNil "d_HC_CLIENT_OBJ") then {
	["d_dodel1", [d_HC_CLIENT_OBJ, d_current_target_index]] call d_fnc_NetCallEventSTO;
} else {
	d_current_target_index execFSM "fsms\DeleteUnits.fsm";
	if (!isNil "d_mines_created" && {!(d_mines_created isEqualTo [])}) then {
		{
			deleteVehicle _x;
		} forEach d_mines_created;
		d_mines_created = [];
	};
};

sleep 4.321;

if (d_WithJumpFlags == 1) then {
	if (d_current_counter < d_MainTargets) then {0 spawn d_fnc_createjumpflag};
};

if (!isNil "d_HC_CLIENT_OBJ") then {
	["d_dodelrspgrps", d_HC_CLIENT_OBJ] call d_fnc_NetCallEventSTO;
} else {
	if !(d_respawn_ai_groups isEqualTo []) then {
		0 spawn {
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
};

d_del_camps_stuff = [];
{
	_flag = _x getVariable "d_FLAG";
	_mar = format ["d_camp%1",_x getVariable "d_INDEX"];
	deleteMarker _mar;
	d_del_camps_stuff pushBack _x;
	if (!isNull _flag) then {
		d_del_camps_stuff pushBack _flag;
	};
} forEach d_currentcamps;
d_currentcamps = [];

sleep 0.245;

if (isNil "d_HC_CLIENT_OBJ") then {
	[d_old_target_pos,d_old_radius] execFSM "fsms\DeleteEmpty.fsm";
} else {
	["d_dodel2", [d_HC_CLIENT_OBJ, [d_old_target_pos, d_old_radius, d_del_camps_stuff]]] call d_fnc_NetCallEventSTO;
	d_del_camps_stuff = nil;
};

if (d_current_counter < d_MainTargets) then {
	if (d_MHQDisableNearMT != 0) then {
		{
			if (alive _x) then {
				_fux = _x getVariable "d_vecfuelmhq";
				if (!isNil "_fux") then {
					if (fuel _x < _fux) then {
						["d_setFuel", [_x, _fux]] call d_fnc_NetCallEventSTO;
					};
					_x setVariable ["d_vecfuelmhq", nil, true];
				};
			};
		} forEach vehicles;
	};
	sleep 15;
	0 spawn d_fnc_createnexttarget;
} else {
	if (d_WithRecapture == 0) then {
		if (d_recapture_indices isEqualTo []) then {
			d_the_end = true; publicVariable "d_the_end";
			0 spawn d_fnc_DomEnd;
		} else {
			0 spawn {
				scriptName "spawn_x_target_clear_waitforrecap";
				while {!(d_recapture_indices isEqualTo [])} do {
					sleep 2.543;
				};
				d_the_end = true; publicVariable "d_the_end";
				0 spawn d_fnc_DomEnd;
			};
		};
	} else {
		d_the_end = true; publicVariable "d_the_end";
		0 spawn d_fnc_DomEnd;
	};
};