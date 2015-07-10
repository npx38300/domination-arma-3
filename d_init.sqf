// by Xeno
//#define __DEBUG__
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom d_init.sqf"];
#define THIS_FILE "d_init.sqf"
#include "x_setup.sqf"

if (!isServer) then {
	call compile preprocessFileLineNumbers "x_init\x_initcommon.sqf";
};

#ifdef __GROUPDEBUG__
if (!isMultiplayer) then {
	call compile preprocessFileLineNumbers "x_shc\x_f\x_shcfunctions.sqf";
};
#endif

call compile preprocessFileLineNumbers "x_common\x_f\x_netinit.sqf";

#include "i_common.sqf"

if (isServer) then {
#include "i_server.sqf"
};

if (!isDedicated) then {
#include "i_client.sqf"
};


if (isDedicated && {d_WithRevive == 0}) then {
	call compile preprocessFileLineNumbers "x_revive.sqf";
};

[0, "d_rep_ar", {_this setDamage 0; _this setFuel 1}] call d_fnc_NetAddEvent;
[0, "d_setcapt", {(_this select 0) setCaptive (_this select 1)}] call d_fnc_NetAddEvent;
[0, "d_eswm", {_this switchMove ""}] call d_fnc_NetAddEvent;
[0, "d_del_ruin", {_ruin = nearestObject [_this, "Ruins"];if (!isNull _ruin) then {deleteVehicle _ruin}}] call d_fnc_NetAddEvent;
["d_lv2", {(_this select 0) lock (_this select 1)}] call d_fnc_NetAddEventSTO;
["d_grpl", {(_this select 0) selectLeader (_this select 1)}] call d_fnc_NetAddEventSTO;
["d_joing", {(_this select 1) join (_this select 0)}] call d_fnc_NetAddEventSTO;
["d_grpslead", {(_this select 1) selectLeader (_this select 2)}] call d_fnc_NetAddEventSTO;
["d_grpjoin", {[_this select 1] joinSilent (_this select 0)}] call d_fnc_NetAddEventSTO;
["d_setFuel", {(_this select 0) setFuel (_this select 1)}] call d_fnc_NetAddEventSTO;
["d_setvel0", {_this setVelocity [0,0,0]}] call d_fnc_NetAddEventSTO;
["d_engineon", {(_this select 0) engineOn (_this select 1)}] call d_fnc_NetAddEventSTO;
["d_delvc", {(_this select 0) deleteVehicleCrew (_this select 1)}] call d_fnc_NetAddEventSTO;
[0, "d_setmass", {
	__TRACE_1("d_setmass","_this")
	(_this select 0) setMass (_this select 1);
	#ifdef __DEBUG__
	_mmm = getMass (_this select 0);
	__TRACE_1("d_setmass","_mmm")
	#endif
}] call d_fnc_NetAddEvent;
if (isServer) then {
	["d_hcready", {
		d_HC_CLIENT_READY = true; /*"d_hcobj" call d_fnc_NetRemoveEventCTS*/
		__TRACE("d_hcready event: d_HC_CLIENT_READY")
	}] call d_fnc_NetAddEventCTS;
	[1, "d_m_box", {_this call d_fnc_CreateDroppedBox}] call d_fnc_NetAddEvent;
	["d_p_group", {
		private "_idx";
		_idx = (_this select 0) getVariable "d_pgidx";
		if (isNil "_idx") then {
			d_player_groups pushBack (_this select 0);
			_idx = d_player_groups_lead pushBack (_this select 1);
			(_this select 0) setVariable ["d_pgidx", _idx];
		} else {
			d_player_groups_lead set [_idx, _this select 1];
		};
	}] call d_fnc_NetAddEventCTS;
	["d_air_taxi", {_this spawn d_fnc_airtaxiserver}] call d_fnc_NetAddEventCTS;
	[1, "d_r_box", {_this call d_fnc_RemABox}] call d_fnc_NetAddEvent;
	["d_p_f_b_k", {_this call d_fnc_KickPlayerBS}] call d_fnc_NetAddEventCTS;
	["d_p_bs", {_this call d_fnc_RptMsgBS}] call d_fnc_NetAddEventCTS;
	["d_pas", {(_this select 0) addScore (_this select 1)}] call d_fnc_NetAddEventCTS;
	["d_p_varn", {_this call d_fnc_GetPlayerArray}] call d_fnc_NetAddEventCTS;
	["d_ad", {d_allunits_add pushBack _this}] call d_fnc_NetAddEventCTS;
	["d_ad2", {(_this select 0) setVariable ["d_end_time", _this select 1];d_allunits_add pushBack (_this select 0)}] call d_fnc_NetAddEventCTS;
	["d_p_o_a", {
		__TRACE_1("d_p_o_a event","_this")
		private ["_ar"];
		_ar = d_placed_objs_store getVariable [_this select 0, []];
		__TRACE_1("d_p_o_a event","_ar")
		_ar pushBack (_this select 1);
		d_placed_objs_store setVariable [_this select 0, _ar];
		_ar = _this select 1;
		__TRACE_1("d_p_o_a event","_ar")
		(_ar select 0) addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_PlacedObjKilled}}];
		if ((_ar select 0) isKindOf d_mash) then {
			[_ar select 1, getPosASL (_ar select 0),"ICON","ColorBlue",[0.5,0.5],format ["Mash %1", _ar select 2],0,"mil_dot"] call d_fnc_CreateMarkerGlobal;
		} else {
			if ((_ar select 0) isKindOf (d_farp_classes select 0)) then {
				[_ar select 1, getPosASL (_ar select 0),"ICON","ColorBlue",[0.5,0.5],format ["FARP %1", _ar select 2],0,"mil_dot"] call d_fnc_CreateMarkerGlobal;
				if (isDedicated) then {
					_farpc = (_ar select 0) getVariable ["d_objcont", []];
					if !(_farpc isEqualTo []) then {
						_trig = _farpc select 0;
						_trig setTriggerActivation ["ANY", "PRESENT", true];
						_trig setTriggerStatements ["(thislist call d_fnc_tchopservice) || {(thislist call d_fnc_tvecservice)} || {(thislist call d_fnc_tjetservice)}", "0 = [thislist] spawn d_fnc_reload", ""];
					};
				};
			};
		};
	}] call d_fnc_NetAddEventCTS;
	["d_p_o_r", {
		__TRACE_1("d_p_o_r event","_this")
		_ar = d_placed_objs_store getVariable [_this select 0, []];
		__TRACE_1("d_p_o_r event","_ar")
		if !(_ar isEqualTo []) then {
			{
				if ((_x select 1) == (_this select 1)) exitWith {_ar deleteAt _forEachIndex};
			} forEach _ar;
		};
		deleteMarker (_this select 1);
		d_placed_objs_store setVariable [_this select 0, _ar];
	}] call d_fnc_NetAddEventCTS;
	["d_ampoi", {
		_ow = (_this select 0) getVariable "d_owner";
		if (!isNil _ow) then {
			_ow addScore (d_ranked_a select 7);
			["d_amap", [_ow, _this select 1]] call d_fnc_NetCallEventSTO;
		};
	}] call d_fnc_NetAddEventCTS;
	["d_p_o_a2", {
		_ar = d_placed_objs_store2 getVariable [_this select 0, []];
		if !(_ar isEqualTo []) then {_ar = _ar - [objNull]};
		_ar pushBack (_this select 1);
		d_placed_objs_store2 setVariable [_this select 0, _ar];
	}] call d_fnc_NetAddEventCTS;
	
	["d_p_o_a2r", {
		_ar = d_placed_objs_store2 getVariable [_this select 0, []];
		if !(_ar isEqualTo []) then {
			_ar = _ar - [_this select 0, objNull];
		};
		d_placed_objs_store2 setVariable [_this select 0, _ar];
	}] call d_fnc_NetAddEventCTS;
	
	["d_x_dr_t", {_this spawn d_fnc_createdrop}] call d_fnc_NetAddEventCTS;
	["d_ari_type", {_this spawn d_fnc_arifire}] call d_fnc_NetAddEventCTS;
	["d_l_v", {if !((_this select 0) in d_wreck_cur_ar) then {if (local (_this select 0)) then {(_this select 0) lock (_this select 1)} else {["d_lv2", _this] call d_fnc_NetCallEventSTO}}}] call d_fnc_NetAddEventCTS;
	[1, "d_mhqdepl", {if (local (_this select 0)) then {(_this select 0) lock (_this select 1)};if (_this select 1) then {(_this select 0) call d_fnc_createMHQEnemyTeleTrig} else {(_this select 0) call d_fnc_removeMHQEnemyTeleTrig}}] call d_fnc_NetAddEvent;
	["d_g_p_inf", {_this call d_fnc_GetAdminArray}] call d_fnc_NetAddEventCTS;
	["d_ad_deltk", {_this call d_fnc_AdminDelTKs}] call d_fnc_NetAddEventCTS;
	["d_crl", {_this call d_fnc_ChangeRLifes}] call d_fnc_NetAddEventCTS;
	["d_unit_tkr", {_this call d_fnc_TKR}] call d_fnc_NetAddEventCTS;
	["d_kbmsg", {_this call d_fnc_DoKBMsg}] call d_fnc_NetAddEventCTS;
	["d_sSetVar", {missionNamespace setVariable [_this select 0, _this select 1]}] call d_fnc_NetAddEventCTS;
	["d_sm_var", {d_sm_winner = _this;d_sm_resolved = true;}] call d_fnc_NetAddEventCTS;
	
	["d_smgetbonus", {
		__TRACE_1("d_smgetbonus event","_this")
		d_sm_winner = _this select 0;
		d_current_sm_bonus_vec = _this select 1;
		__TRACE("d_smgetbonus event: FUNC getbonus")
		0 spawn d_fnc_getbonus;
	}] call d_fnc_NetAddEventCTS;
	
	["d_getSM", {0 spawn d_fnc_getsidemission}] call d_fnc_NetAddEventCTS;
	
	["d_setgrps", {_this setVariable ["d_fromHC", true]}] call d_fnc_NetAddEventCTS;
	
	["d_nHCObj", {d_HC_CLIENT_OBJ = _this}] call d_fnc_NetAddEventCTS;
	
	["d_crbike", {_this call d_fnc_createPlayerBike}] call d_fnc_NetAddEventCTS;
	
	["d_grssrv", {[_this, 1] call d_fnc_setgstate}] call d_fnc_NetAddEventCTS;
	
	["d_c_m_g", {
		__TRACE_1("d_c_m_g event","_this")
		_this call d_fnc_CreateMarkerGlobal;
	}] call d_fnc_NetAddEventCTS;
	["d_d_m_g", {
		__TRACE_1("d_d_m_g event","_this")
		deleteMarker _this;
	}] call d_fnc_NetAddEventCTS;
	["d_s_mc_g", {
		__TRACE_1("d_s_mc_g event","_this")
		(_this select 0) setMarkerColor (_this select 1)
	}] call d_fnc_NetAddEventCTS;
	["d_s_mrecap_g", {
		__TRACE_1("d_s_mrecap_g event","_this")
		private "_mtm";
		_mtm = "d_" + (_this select 0) + "_dommtm";
		_mtm setMarkerColor (_this select 1);
		_mtm setMarkerBrush (_this select 2);
	}] call d_fnc_NetAddEventCTS;
	["d_s_sm_up", {
		__TRACE_1("d_s_sm_up event","_this")
		private ["_posi_array"];
		d_cur_sm_idx = [_this, 0] call BIS_fnc_param;
		publicVariable "d_cur_sm_idx";
		_posi_array = [_this, 1] call BIS_fnc_param;
		d_x_sm_type = [_this, 2] call BIS_fnc_param;
		
		if (d_x_sm_type == "normal") then {
			[format ["d_XMISSIONM%1", d_cur_sm_idx + 1],_posi_array select 0,"ICON","ColorRed",[1,1],localize "STR_DOM_MISSIONSTRING_707",0,"hd_destroy"] call d_fnc_CreateMarkerGlobal;
		} else {
			if (d_x_sm_type == "convoy") then {
				[format ["d_XMISSIONM%1", d_cur_sm_idx + 1], _posi_array select 0,"ICON","ColorRed",[1,1],localize "STR_DOM_MISSIONSTRING_708",0,"hd_start"] call d_fnc_CreateMarkerGlobal;
				[format ["d_XMISSIONM2%1", d_cur_sm_idx + 1], _posi_array select 1,"ICON","ColorRed",[1,1],localize "STR_DOM_MISSIONSTRING_709",0,"mil_pickup"] call d_fnc_CreateMarkerGlobal;
			};
		};
		["d_up_m"] call d_fnc_NetCallEventToClients;
		d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"NewMission","SIDE"];
		d_sm_resolved = false;
		d_sm_winner = 0;
	}] call d_fnc_NetAddEventCTS;
	["d_d_sm_mar", {
		__TRACE_1("d_d_sm_mar event","_this")
		deleteMarker (format ["d_XMISSIONM%1",_this]);
		if (d_x_sm_type == "convoy" || {d_x_sm_type == "deliver"}) then {deleteMarker (format ["d_XMISSIONM2%1", _this])};
	}] call d_fnc_NetAddEventCTS;
	["d_at_serv", {
		__TRACE_1("d_at_serv event","_this")
		private ["_pl", "_apos", "_mname", "_npl", "_aritype", "_ari_salv"];
		_pl = [_this, 0] call BIS_fnc_param;
		_apos = [_this, 1] call BIS_fnc_param;
		_npl = [_this, 2] call BIS_fnc_param;
		_aritype = [_this, 3] call BIS_fnc_param;
		_ari_salv = [_this, 4] call BIS_fnc_param;
		
		_mname = "d_arttmx|" + (if (isMultiplayer) then {netId _pl} else {"1"}) + "|" + _aritype + "|" + str(_ari_salv); // not sure if netId really works as sqf is limited to 22 Bit numbers
		__TRACE_1("d_at_serv event","_mname")
		_pa = d_player_store getVariable (getPlayerUID _pl);
		if (!isNil "_pa") then {
			_omar = _pa select 10;
			__TRACE_1("d_at_serv event","_omar")
			if (_omar != "" && {markerType _omar != ""}) then {
				deleteMarker _omar;
			};
			_pa set [10, _mname];
		};
		[_mname, _apos, "ICON", d_color_m_marker, [1,1], _npl, 0, d_arty_m_marker] call d_fnc_CreateMarkerGlobal;
		if (!d_with_ai && {d_with_ai_features == 1}) then {
			{
				_aunit = missionNamespace getVariable _x;
				__TRACE_1("d_at_serv event","_aunit")
				if (!isNil "_aunit" && {!isNull _aunit} && {_aunit != _pl}) then {
					["d_upd_aop", [_aunit, _npl]] call d_fnc_NetCallEventSTO;
				};
			} forEach d_can_use_artillery;
		};
	}] call d_fnc_NetAddEventCTS;
	["d_e_s_g", {
		__TRACE_1("d_e_s_g event","_this")
		(_this select 0) enableSimulation (_this select 1);
	}] call d_fnc_NetAddEventCTS;
	["d_h_o_g", {
		__TRACE_1("d_h_o_g event","_this")
		hideObjectGlobal _this;
	}] call d_fnc_NetAddEventCTS;
	["d_mhq_net", {
		__TRACE_1("d_mhq_net event","_this")
		_pmpos = getPosATL _this;
		_pmpos set [2, 0];
		__TRACE_1("","_pmpos")
		_camo = createVehicle [d_vec_camo_net, _pmpos, [], 0, "NONE"];
		_camo setDir getDir _this;
		_camo setVectorUp (vectorUp _this);
		_camo setPos _pmpos;		
		_this setVariable ["d_MHQ_Camo", _camo, true];
		_camo addEventhandler ["killed", {deleteVehicle (_this select 0)}];
	}] call d_fnc_NetAddEventCTS;
};

#include "x_missions\x_missionssetup.sqf"

if (isServer && {!isDedicated}) then {d_date_str = date};

{_x allowDamage false} count (nearestObjects [d_FLAG_BASE, ["Land_Airport_Tower_F", "Land_MilOffices_V1_F","Land_Airport_right_F","Land_Airport_center_F","Land_Airport_left_F"], 70]);

if (isSteamMission) exitWith {endMission "LOSER"};

if (isNil "d_target_clear") then {
	d_target_clear = false;
};
if (isNil "d_all_sm_res") then {
	d_all_sm_res = false;
};
if (isNil "d_the_end") then {
	d_the_end = false;
};
if (isNil "d_ari_available") then {
	d_ari_available = true;
};
if (isNil "d_current_target_index") then {
	d_current_target_index = -1;
};
if (isNil "d_cur_sm_idx") then {
	d_cur_sm_idx = -1;
};
if (isNil "d_num_ammo_boxes") then {
	d_num_ammo_boxes = 0;
};
if (isNil "d_sec_kind") then {
	d_sec_kind = 0;
};
if (isNil "d_resolved_targets") then {
	d_resolved_targets = [];
};
if (isNil "d_ammo_boxes") then {
	d_ammo_boxes = [];
};
if (isNil "d_para_available") then {
	d_para_available = true;
};
if (isNil "d_searchbody") then {
	d_searchbody = objNull;
};
if (isNil "d_searchintel") then {
	d_searchintel = [0,0,0,0,0,0];
};
if (isNil "d_ari_blocked") then {
	d_ari_blocked = false;
};
if ((d_with_ai || {d_with_ai_features == 0}) && {isNil "d_drop_blocked"}) then {
	d_drop_blocked = false;
};
if (isNil "d_numcamps") then {
	d_numcamps = 0;
};
if (isNil "d_campscaptured") then {
	d_campscaptured = 0;
};
if (isNil "d_farps") then {
	d_farps = [];
};
if (isNil "d_mashes") then {
	d_mashes = [];
};

if (isServer) then {
	execVM "x_bikb\kbinit.sqf";
	
	["d_drop_zone", [0,0,0], "ICON", "ColorBlue", [1,1], localize "STR_DOM_MISSIONSTRING_500", 0, "mil_dot"] call d_fnc_CreateMarkerGlobal;
	
	call compile preprocessFileLineNumbers "x_server\x_initx.sqf";
	
	if (d_weather == 0) then {execFSM "fsms\WeatherServer.fsm"};

	// create random list of targets
	d_maintargets_list = call d_fnc_createrandomtargets;
	//d_maintargets_list = [0,1,2,3];
	__TRACE_1("","d_maintargets_list")
	
	// create random list of side missions
	d_side_missions_random = d_sm_array call d_fnc_RandomArray;
	__TRACE_1("","d_side_missions_random")
	
	d_current_counter = 0;
	d_current_mission_counter = 0;

	// editor varname, unique number, true = respawn only when the chopper is completely destroyed, false = respawn after some time when no crew is in the chopper or chopper is destroyed
	// unique number must be between 3000 and 3999
	[[d_chopper_1,3001,true],[d_chopper_2,3002,true],[d_chopper_3,3003,false,1500],[d_chopper_4,3004,false,1500],[d_chopper_5,3005,false,600],[d_chopper_6,3006,false,600],[d_chopper_7,3007,false,1500],[d_chopper_8,3008,false,1500],[d_chopper_9,3009,false,1500]] execVM "x_server\x_helirespawn2.sqf";
	// editor varname, unique number
	//0-99 = MHQ, 100-199 = Medic vehicles, 200-299 = Fuel, Repair, Reammo trucks, 300-399 = Engineer Salvage trucks, 400-499 = Transport trucks
	[
		[d_vec_mhq_1,0],[d_vec_mhq_2,1],[d_vec_med_1,100],[d_vec_rep_1,200],[d_vec_fuel_1,201],[d_vec_ammo_1,202], [d_vec_rep_2,203],
		[d_vec_fuel_2,204], [d_vec_ammo_2,205], [d_vec_eng_1,300], [d_vec_eng_2,301], [d_vec_trans_1,400], [d_vec_trans_2,401],[d_chopper_7,101],
		[d_chopper_8,206],[d_chopper_9,207]
	] execVM "x_server\x_vrespawn2.sqf";
	if (!isNil "d_boat_1") then {execFSM "fsms\Boatrespawn.fsm"};
	[d_wreck_rep,localize "STR_DOM_MISSIONSTRING_0",d_heli_wreck_lift_types] execFSM "fsms\RepWreck.fsm";

	call compile preprocessFileLineNumbers "x_server\x_setupserver.sqf";
	if (d_MissionType != 2) then {0 spawn d_fnc_createnexttarget};
	
	if (d_with_ai) then {
		d_player_groups = [];
		d_player_groups_lead = [];
	};
	
	addMissionEventHandler ["HandleDisconnect", {_this call d_fnc_handledisconnect}];
};

if (!isDedicated) then {
	["d_wreck_service", getPosASL d_wreck_rep,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_1",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_aircraft_service", getPosASL d_jet_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_2",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_chopper_service", getPosASL d_chopper_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_3",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_vehicle_service", getPosASL d_vecre_trigger,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_4",0,"n_service"] call d_fnc_CreateMarkerLocal;
	["d_Ammobox_Reload", getPosASL d_AMMOLOAD,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_5",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
	["d_teleporter", getPosASL d_FLAG_BASE,"ICON","ColorYellow",[1,1],localize "STR_DOM_MISSIONSTRING_6",0,"mil_flag"] call d_fnc_CreateMarkerLocal;
};

d_init_processed = true;

if (!isMultiplayer && {!isDedicated}) then {
	d_player_stuff = [d_AutoKickTime, time, "", 0, str player, 0, name player, 0, xr_max_lives, 0, ""];
	d_player_store setVariable ["", d_player_stuff];
};

d_d_init_ready = true;
diag_log [diag_frameno, diag_ticktime, time, "Dom d_init.sqf processed"];