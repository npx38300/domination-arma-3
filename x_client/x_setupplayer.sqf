// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_setupplayer.sqf"
#include "x_setup.sqf"

diag_log [diag_frameno, diag_ticktime, time, "Executing Dom x_setupplayer.sqf"];

d_name_pl = name player;
d_string_player = str player;
d_player_side = playerSide;

// no idea if the following really works and it should never happen!
if (isNull (group player)) then {
	_gside = if ((faction player) in ["USMC","CDF","BIS_US","BIS_CZ","BIS_GER","BIS_BAF","BLU_F","BLU_G_F"]) then {blufor} else {opfor};
	_grpp = createGroup blufor;
	[player] joinSilent _grpp;
};
if (side (group player) != d_player_side) then {
	d_player_side = side (group player);
};

player setVariable ["d_tk_cutofft", -1];
player setVariable ["xr_pluncon", false];
player setVariable ["d_last_gear_save", -1];
if (d_WithRevive == 1) then {
	player setVariable ["d_phd_eh", player addEventHandler ["handleDamage", {_this call xr_fnc_ClientHD}]];
};

if (d_with_ranked) then {d_sm_p_pos = nil};

if (!isServer) then {execVM "x_bikb\kbinit.sqf"};

["d_dummy_marker", [0,0,0],"ICON","ColorBlack",[1,1],"",0,"Empty"] call d_fnc_CreateMarkerLocal;

if (d_the_end) exitWith {
	endMission "END1";
	forceEnd;
};

["d_the_end", {
	if (_this == 0) then {
		if (isNil "d_end_cam_running") then {
			execVM "x_client\x_endcam.sqf";
		};
	} else {
		endMission "END1";
		forceEnd;
	};
}] call d_fnc_NetAddEventToClients;
["d_recaptured", {_this call d_fnc_RecapturedUpdate}] call d_fnc_NetAddEventToClients;
["d_doarti", {
	if (alive player && {player distance _this < 50} && {!(player getVariable ["xr_pluncon", false])}) then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_501");
	};
}] call d_fnc_NetAddEventToClients;
[2, "d_m_box", {_this call d_fnc_create_boxNet}] call d_fnc_NetAddEvent;
[2, "d_r_box", {
	private ["_nobjs", "_box", "_unit"];
	_nobjs = nearestObjects [_this select 0, [d_the_box], 10];
	__TRACE_2("r_box","_nobjs","_this")
	if !(_nobjs isEqualTo []) then {
		_box = _nobjs select 0;
		_unit = _this select 1;
		if (!isNil "_unit" && {!isNull _unit}) then {
			_unit setVariable ["d_boxcargo", [_box call BIS_fnc_getVirtualWeaponCargo, _box call BIS_fnc_getVirtualMagazineCargo, _box call BIS_fnc_getVirtualItemCargo, _box call BIS_fnc_getVirtualBackpackCargo]];
		};
		deleteVehicle _box;
	};
}] call d_fnc_NetAddEvent;

["d_air_box", {
_box = d_the_box createVehicleLocal _this;
_box setPos [_this select 0, _this select 1, 0];
player reveal _box;
[_box] call d_fnc_weaponcargo;
_box addAction ["<t color='#FF0000'>Virtual Ammobox System (VAS)</t>", "VAS\open.sqf", [], 6, true, true, "", "vehicle _this == _this && _this distance getPos _target < 6"];
_box addEventHandler ["killed", {deleteVehicle (_this select 0);}];
}] call d_fnc_NetAddEventToClients;

["d_sm_res_client", {
	__TRACE_1("sm_res_client _this","_this")
	playSound "d_Notebook";
	d_sm_winner = _this select 0;
	if (d_with_ranked) then {
		d_sm_running = false
	};
	(_this select 1) spawn d_fnc_sidemissionwinner
}] call d_fnc_NetAddEventToClients;
["d_target_clear", {playSound "d_fanfare";_this spawn d_fnc_target_clear_client}] call d_fnc_NetAddEventToClients;
["d_update_target", {0 spawn d_fnc_createnexttargetclient}] call d_fnc_NetAddEventToClients;
["d_up_m", {
	__TRACE("up_m getsidemissionclient")
	[true] call d_fnc_getsidemissionclient;
}] call d_fnc_NetAddEventToClients;
["d_unit_tk", {
	if (d_sub_tk_points != 0) then {
		[format [localize "STR_DOM_MISSIONSTRING_502", _this select 0, _this select 1, d_sub_tk_points], "GLOBAL"] call d_fnc_HintChatMsg;
	} else {
		[format [localize "STR_DOM_MISSIONSTRING_503", _this select 0, _this select 1], "GLOBAL"] call d_fnc_HintChatMsg;
	};
}] call d_fnc_NetAddEventToClients;
["d_unit_tk2", {
	if (d_sub_tk_points != 0) then {
		[format [localize "STR_DOM_MISSIONSTRING_504", _this select 0, _this select 1, d_sub_tk_points], "GLOBAL"] call d_fnc_HintChatMsg;
	} else {
		[format [localize "STR_DOM_MISSIONSTRING_505", _this select 0, _this select 1], "GLOBAL"] call d_fnc_HintChatMsg;
	};
}] call d_fnc_NetAddEventToClients;
["d_ataxi", {_this call d_fnc_ataxiNet}] call d_fnc_NetAddEventSTO;
["d_sm_p_pos", {d_sm_p_pos = _this}] call d_fnc_NetAddEventToClients;
["d_mt_winner", {d_mt_winner = _this}] call d_fnc_NetAddEventToClients;
["d_n_v", {_this call d_fnc_initvec}] call d_fnc_NetAddEventToClients;
[2, "d_mhqdepl", {
	if (local (_this select 0)) then {
		(_this select 0) lock (_this select 1);
	};
	_this call d_fnc_mhqdeplNet;
}] call d_fnc_NetAddEvent;
["d_w_n", {[format [localize "STR_DOM_MISSIONSTRING_506", _this select 0, _this select 1], "GLOBAL"] call d_fnc_HintChatMsg}] call d_fnc_NetAddEventToClients;
["d_tk_an", {
	[format [localize "STR_DOM_MISSIONSTRING_507", _this select 0, _this select 1], "GLOBAL"] call d_fnc_HintChatMsg;
	// TODO move serverCommand to UI
	if (d_pisadminp) then {serverCommand ("#kick " + (_this select 0))};
}] call d_fnc_NetAddEventToClients;
["d_saat", {[format [localize "STR_DOM_MISSIONSTRING_1462", name _this], "GLOBAL"] call d_fnc_HintChatMsg;}] call d_fnc_NetAddEventToClients;
["d_em", {endMission "LOSER"}] call d_fnc_NetAddEventSTO;
["d_ps_an", {
	switch (_this select 1) do {
		case 0: {[format [localize "STR_DOM_MISSIONSTRING_508", _this select 0], "GLOBAL"] call d_fnc_HintChatMsg};
		case 1: {[format [localize "STR_DOM_MISSIONSTRING_509", _this select 0], "GLOBAL"] call d_fnc_HintChatMsg};
	};
	// TODO move serverCommand to UI
	if (d_pisadminp) then {serverCommand ("#kick " + (_this select 0))};
}] call d_fnc_NetAddEventToClients;
["d_s_p_inf", {d_u_r_inf = _this}] call d_fnc_NetAddEventSTO;
if (d_with_ranked) then {
	["d_pho", {[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_288", d_ranked_a select 17]}] call d_fnc_NetAddEventSTO;
};

["d_farp_e", {
	if (d_eng_can_repfuel) then {
		(_this select 0) addAction [(localize "STR_DOM_MISSIONSTRING_513") call d_fnc_BlueText, {_this call d_fnc_restoreeng}];
	};
	if (_this select 1 != player) then {
		_farpc = (_this select 0) getVariable ["d_objcont", []];
		if !(_farpc isEqualTo []) then {
			_trig = _farpc select 0;
			_trig setTriggerActivation ["ANY", "PRESENT", true];
			_trig setTriggerStatements ["(thislist call d_fnc_tchopservice) || {(thislist call d_fnc_tvecservice)} || {(thislist call d_fnc_tjetservice)}", "0 = [thislist] spawn d_fnc_reload", ""];
		};
	};
}] call d_fnc_NetAddEventToClients;

["d_p_o_an", {_this call d_fnc_PlacedObjAn}] call d_fnc_NetAddEventToClients;
["d_dropansw", {_this call d_fnc_dropansw}] call d_fnc_NetAddEventSTO;
["d_n_jf", {if (d_WithJumpFlags == 1) then {_this call d_fnc_newflagclient}}] call d_fnc_NetAddEventToClients;
["d_s_b_client", {
	d_searchbody setVariable ["d_search_id", d_searchbody addAction [localize "STR_DOM_MISSIONSTRING_518", {_this spawn d_fnc_searchbody}]];
}] call d_fnc_NetAddEventToClients;
["d_rem_sb_id", {
	if (!isNil {d_searchbody getVariable "d_search_id"}) then {
		d_searchbody removeAction (d_searchbody getVariable "d_search_id");
	};
}] call d_fnc_NetAddEventToClients;
["d_intel_upd", {_this call d_fnc_intel_updNet}] call d_fnc_NetAddEventToClients;

["d_mqhtn", {[format [localize "STR_DOM_MISSIONSTRING_520", d_MHQDisableNearMT, _this], "HQ"] call d_fnc_HintChatMsg}] call d_fnc_NetAddEventToClients;

["d_ccso", {playSound "d_Ui_cc"}] call d_fnc_NetAddEventToClients;

["d_grpswmsg", {if (_this select 2 != player) then {systemChat ((_this select 1) + " " + localize "STR_DOM_MISSIONSTRING_1432")}}] call d_fnc_NetAddEventSTO;
["d_grpswmsgn", {systemChat ((_this select 1) + " " + localize "STR_DOM_MISSIONSTRING_1433")}] call d_fnc_NetAddEventSTO;

["d_vboxrefi", {_this setVariable ["d_boxcargo", nil]}] call d_fnc_NetAddEventToClients;

["d_kbunits", {
	if (_this select 1 != side (group player)) exitWith {};
	(missionNamespace getVariable (_this select 0)) kbAddTopic["PL" + str player,"x_bikb\domkba3.bikb"];
}] call d_fnc_NetAddEventToClients;

["d_m_a_h_a", {
	if (player != _this select 1) then {
		(_this select 0) addAction [(localize "STR_DOM_MISSIONSTRING_286a") call d_fnc_RedText, {_this call d_fnc_healatmash}, 0, -1, false, false, "", "damage player > 0 && {alive player} && {!(player getVariable 'xr_pluncon')} && {!(player getVariable 'd_isinaction')}"];
	};
}] call d_fnc_NetAddEventToClients;

["d_amap", {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_287", [d_ranked_a select 7, _this select 1]];
}] call d_fnc_NetAddEventSTO;

["d_stocbike", {
	private "_vec";
	_vec = _this select 1;
	player reveal _vec;
	player moveInDriver _vec;

	if (_vec isKindOf "Quadbike_01_Base_F") then {
		_vec addAction [(localize "STR_DOM_MISSIONSTRING_162") call d_fnc_BlueText, {_this call d_fnc_flipatv}, 0, -1, false, false, "", "!(player in _target) && {((vectorUpVisual _target) select 2) < 0.6}"];
	};

	if (player getVariable "d_bike_b_mode" == 1) then {
		_vec spawn {
			scriptName "spawn_x_bike_1";
			private "_vec";
			_vec = _this;
			waitUntil {sleep 0.412;!alive player || {!alive _vec}};
			sleep 10.123;
			while {true} do {
				if (_vec call d_fnc_GetVehicleEmpty) exitWith {deleteVehicle _vec};
				sleep 15.123;
			};
		};
	} else {
		d_flag_vec = _vec;
		d_flag_vec addEventHandler ["killed", {
			(_this select 0) spawn {
				private ["_vec"];
				_vec = _this;
				sleep 10.123;
				while {true} do {
					if (isNull _vec) exitWith {};
					if (_vec call d_fnc_GetVehicleEmpty) exitWith {deleteVehicle _vec};
					sleep 15.123;
				};
				d_flag_vec = objNull;
			}
		}];
	};
}] call d_fnc_NetAddEventSTO;

["d_upd_sup", {call d_fnc_updatesupportrsc}] call d_fnc_NetAddEventToClients;

["d_upd_aop", {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_1522", _this select 1];
	playSound "d_Notebook";
}] call d_fnc_NetAddEventSTO;

0 spawn {
	waitUntil {!d_still_in_intro};
	999123 cutRsc ["d_fpsresource","PLAIN"];
	["d_dfps", {
		disableSerialization;
		_disp = (uiNamespace getVariable "d_fpsresource");
		if (!isNil "_disp") then {
			(_disp displayCtrl 50) ctrlSetText str _this;
			(_disp displayCtrl 51) ctrlSetText str diag_fps;
		};
	}] call d_fnc_NetAddEventToClients;
	if (d_player_can_call_arti > 0 || {d_player_can_call_drop > 0}) then {
		999124 cutRsc ["d_RscSupportL", "PLAIN"];
	};
};

["d_a_is_w", {localize "STR_DOM_MISSIONSTRING_1519"}] call d_fnc_NetAddEventSTO;

0 spawn {
	scriptName "spawn_playerstuff";
	sleep 1 + random 3;
	if (isMultiplayer) then {
		waitUntil {!isNil "d_scda"};
		d_scda call d_fnc_player_stuff;
		waitUntil {!d_still_in_intro};
		xr_phd_invulnerable = false;
		sleep 2;
		player setVariable ["d_player_old_rank", 0];
		["itemAdd", ["dom_player_rank", {call d_fnc_PlayerRank}, 5.12]] call bis_fnc_loop;
	} else {
		d_player_autokick_time = d_AutoKickTime;
		xr_phd_invulnerable = false;
		sleep 20;
		if (d_still_in_intro) then {
			d_still_in_intro = false;
		};
	};
};

d_init_vecs_once = ["DOM_INIT_VECS_ID", "onEachFrame", {
	{_x call d_fnc_initvec} forEach vehicles;
	[d_init_vecs_once, "onEachFrame"] call bis_fnc_removeStackedEventHandler;
	d_init_vecs_once = nil;
}] call bis_fnc_addStackedEventHandler;

if (d_with_ranked) then {
	// basic rifle at start
	_weapp = "";
	_magp = "";
	switch (d_own_side) do {
		case "BLUFOR": {
			_weapp = "arifle_MX_F";
			_magp = "30Rnd_65x39_caseless_mag";
		};
		case "OPFOR": {
			_weapp = "arifle_MX_F";
			_magp = "30Rnd_65x39_caseless_mag";
		};
		case "INDEPENDENT": {
			_weapp = "arifle_MX_F";
			_magp = "30Rnd_65x39_caseless_mag";
		};
	};
	removeAllWeapons player;
	player addMagazines [_magp, 6];
	player addWeapon _weapp;

	player setVariable ["d_pprimweap", primaryWeapon player];
	player setVariable ["d_psecweap", secondaryWeapon player];
	player setVariable ["d_phandgweap", handgunWeapon player];
	player setVariable ["d_pprimweapitems", primaryWeaponItems player];
	player setVariable ["d_psecweapitems", secondaryWeaponItems player];
	player setVariable ["d_phandgweapitems", handgunItems player];
	player addEventhandler ["Take", {_this call d_fnc_ptakeweapon}];
	player addEventhandler ["Put", {_this call d_fnc_pputweapon}];
};

if (d_MissionType != 2) then {
	if !(d_resolved_targets isEqualTo []) then {
		for "_i" from 0 to (count d_resolved_targets - 1) do {
			if (isNil "d_resolved_targets" || {_i >= count d_resolved_targets}) exitWith {};
			_res = d_resolved_targets select _i;
			if (!isNil "_res" && {_res >= 0}) then {
				_target_array = d_target_names select _res;
				_cur_tgt_pos = _target_array select 0;
				_cur_tgt_name = _target_array select 1;
				_strtas = format ["d_task%1", _res + 2];
				missionNamespace setVariable [_strtas, player createSimpleTask [format ["d_obj%1", _res + 2]]];
				_ntask = missionNamespace getVariable _strtas;
				_ntask setSimpleTaskDescription [
					format [localize "STR_DOM_MISSIONSTRING_202", _cur_tgt_name],
					format [localize "STR_DOM_MISSIONSTRING_203", _cur_tgt_name],
					format [localize "STR_DOM_MISSIONSTRING_203", _cur_tgt_name]
				];
				_no = missionNamespace getVariable format ["d_target_%1", _res];
				_ntask setTaskstate (if (!isNull _no && {!isNil {_no getVariable "d_recaptured"}}) then {
					"Failed"
				} else {
					"Succeeded"
				});
				_ntask setSimpleTaskDestination _cur_tgt_pos;
			};
		};
	};

	d_current_seize = "";
	if (d_current_target_index != -1 && {!d_target_clear}) then {
		_cur_tidx = d_current_target_index;
		_tgt_ar = d_target_names select _cur_tidx;
		d_current_seize = _tgt_ar select 1;
		_cur_tgt_pos = _tgt_ar select 0;
		"d_dummy_marker" setMarkerPosLocal _cur_tgt_pos;

		_strtas = format ["d_task%1",_cur_tidx + 2];
		missionNamespace setVariable [_strtas, player createSimpleTask [format ["d_obj%1", _cur_tidx + 2]]];
		_ntask = missionNamespace getVariable _strtas;
		_ntask setSimpleTaskDescription [
			format [localize "STR_DOM_MISSIONSTRING_202", d_current_seize],
			format [localize "STR_DOM_MISSIONSTRING_203", d_current_seize],
			format [localize "STR_DOM_MISSIONSTRING_203", d_current_seize]
		];
		_ntask setTaskstate "Created";
		_ntask setSimpleTaskDestination _cur_tgt_pos;
		d_current_task = _ntask;
		player setCurrentTask _ntask;
	};
};

if (d_MissionType != 2) then {
	{
		if (!isNil {_x getVariable "d_is_jf"} && {isNil {_x getVariable "d_jf_id"}}) then {
			if (d_jumpflag_vec == "") then {
				_x setVariable ["d_jf_id", _x addAction [(localize "STR_DOM_MISSIONSTRING_296") call d_fnc_BlueText,{_this spawn d_fnc_paraj}]];
			} else {
				_x setVariable ["d_jf_id", _x addAction [(format [localize "STR_DOM_MISSIONSTRING_297", [d_jumpflag_vec, "CfgVehicles"] call d_fnc_GetDisplayName]) call d_fnc_BlueText,{_this spawn d_fnc_bike},[d_jumpflag_vec,1]]];
			};
		};
	} forEach (allMissionObjects d_flag_pole);
};

if (d_all_sm_res) then {d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_522"} else {[false] call d_fnc_getsidemissionclient};

player addMPEventHandler ["MPKilled", {_this call d_fnc_plcheckkill}];
player addEventHandler ["respawn", {_this call d_fnc_prespawned}];

if !(d_ammo_boxes isEqualTo []) then {
	private ["_box_pos", "_boxnew"];
	{
		if (typeName _x == "ARRAY") then {
			_box_pos = _x select 0;
			_boxnew = d_the_box createVehicleLocal _box_pos;
			_boxnew setPos _box_pos;
			[_boxnew] call d_fnc_weaponcargo;
			_boxnew allowDamage false;
		};
	} forEach d_ammo_boxes;
};

player setVariable ["d_isinaction", false];

#define __scale3 _scale = 0.032 - (_distp / 9000); \
_pos set [2, 5 + (_distp * 0.05)]; \
_alpha = 1 - (_distp / 200)

0 spawn {
	waitUntil {!d_still_in_intro};
	d_d3d_locs = [
		localize "STR_DOM_MISSIONSTRING_524",
		localize "STR_DOM_MISSIONSTRING_526",
		localize "STR_DOM_MISSIONSTRING_528",
		localize "STR_DOM_MISSIONSTRING_0",
		localize "STR_DOM_MISSIONSTRING_531"
	];
	addMissionEventHandler ["Draw3D", {
		if (player distance d_FLAG_BASE < 1000) then {
			_pos = getPosATL d_vecre_trigger;
			_distp = player distance _pos;
			if (_distp < 200) then {
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs select 0, 1, _scale, "TahomaB"];
			};
			_pos = getPosATL d_jet_trigger;
			_distp = player distance _pos;
			if (_distp < 200) then {
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs select 1, 1, _scale, "TahomaB"];
			};
			_pos = getPosATL d_chopper_trigger;
			_distp = player distance _pos;
			if (_distp < 200) then {
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0,  d_d3d_locs select 2, 1, _scale, "TahomaB"];
			};
			_pos = getPosATL d_wreck_rep;
			_distp = player distance _pos;
			if (_distp < 200) then {
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs select 3, 1, _scale, "TahomaB"];
			};
			_pos = getPosATL d_AMMOLOAD;
			_distp = player distance _pos;
			if (_distp < 200) then {
				__scale3;
				drawIcon3D ["#(argb,8,8,3)color(0,0,0,0)", [0,0,1,_alpha], _pos, 1, 1, 0, d_d3d_locs select 4, 1, _scale, "TahomaB"];
			};
		};
	}];
};

diag_log ["Internal D Version: 3.08"];

if (d_with_ai || {d_with_ai_features == 0}) then {
	if (d_with_ai) then {
		if (isNil "d_AI_HUT") then {
			0 spawn {
				scriptName "spawn_wait_for_ai_hut";
				waitUntil {sleep 0.512; !isNil "d_AI_HUT"};
				call compile preprocessFileLineNumbers "x_client\x_recruitsetup.sqf";
			};
		} else {
			call compile preprocessFileLineNumbers "x_client\x_recruitsetup.sqf";
		};

		_grpp = group player;
		_leader = leader _grpp;
		if (!isPlayer _leader || {player == _leader}) then {
			{
				if (!isPlayer _x) then {
					if (vehicle _x == _x) then {
						deleteVehicle _x;
					} else {
						["d_delvc", [vehicle _x, _x]] call d_fnc_NetCallEventSTO;
					};
				};
			} forEach units _grpp;
		};
	};

	d_player_can_call_arti = 1;
	d_player_can_call_drop = 1;
} else {
	if (d_string_player in d_can_use_artillery) then {
		d_player_can_call_arti = 1;
	} else {
		enableEngineArtillery false;
	};
	if (d_string_player in d_can_call_drop_ar) then {
		d_player_can_call_drop = 1;
	};
};

_respawn_marker = "";
switch (d_own_side) do {
	case "INDEPENDENT": {
		_respawn_marker = "respawn_guerrila";
		deleteMarkerLocal "respawn_west";
		deleteMarkerLocal "respawn_east";
	};
	case "BLUFOR": {
		_respawn_marker = "respawn_west";
		deleteMarkerLocal "respawn_guerrila";
		deleteMarkerLocal "respawn_east";
	};
	case "OPFOR": {
		_respawn_marker = "respawn_east";
		deleteMarkerLocal "respawn_west";
		deleteMarkerLocal "respawn_guerrila";
	};
};

_respawn_marker setMarkerPosLocal markerPos "base_spawn_1";

player setVariable ["d_custom_backpack", []];
player setVariable ["d_player_backpack", []];

d_base_trigger = d_base_trigger_d;
d_base_trigger setTriggerArea [d_base_array select 1, d_base_array select 2, d_base_array select 3, true];
d_base_trigger setTriggerActivation [d_own_side_trigger, "PRESENT", true];
d_base_trigger setTriggerStatements["this", "", ""];

// special triggers for engineers, AI version, everybody can repair and flip vehicles
if (d_string_player in d_is_engineer || {d_with_ai} || {d_with_ai_features == 0}) then {
	d_eng_can_repfuel = true;

	if (d_engineerfull == 0 || {d_with_ai} || {d_with_ai_features == 0}) then {
		d_engineer_trigger = d_engineer_trigger_d;
		d_engineer_trigger setTriggerArea [d_base_array select 1, d_base_array select 2, d_base_array select 3, true];
		d_engineer_trigger setTriggerActivation [d_own_side_trigger, "PRESENT", true];
		d_engineer_trigger setTriggerStatements["!d_eng_can_repfuel && {player in thislist}", "d_eng_can_repfuel = true;systemChat (localize 'STR_DOM_MISSIONSTRING_340')", ""];
	};

	if (d_with_ranked) then {d_last_base_repair = -1};

	["itemAdd", ["dom_eng_1_trig", {
		if (player getVariable "d_has_ffunc_aid" == -9999 && {player call d_fnc_hastoolkit} && {call d_fnc_ffunc}) then {
			d_actionID1 = player addAction [(localize 'STR_DOM_MISSIONSTRING_1408') call d_fnc_GreyText, {_this call d_fnc_unflipVehicle},[d_objectID1],-1,false];
			player setVariable ["d_has_ffunc_aid", d_actionID1];
		} else {
			if (player getVariable "d_has_ffunc_aid" != -9999 && {!(call d_fnc_ffunc)}) then {
				player removeAction d_actionID1;
				player setVariable ["d_has_ffunc_aid", -9999];
			};
		};
	}, 0.51]] call bis_fnc_loop;

	if (d_engineerfull == 0 || {d_with_ai} || {d_with_ai_features == 0}) then {
		player setVariable ["d_has_sfunc_aid", false];
		["itemAdd", ["dom_eng_2_trig", {
			if (!(player getVariable "d_has_sfunc_aid") && {player call d_fnc_hastoolkit} && {call d_fnc_sfunc}) then {
				d_actionID6 = player addAction [(localize "STR_DOM_MISSIONSTRING_1509") call d_fnc_GreyText, {_this call d_fnc_repanalyze},[],-1,false];
				d_actionID2 = player addAction [(localize "STR_DOM_MISSIONSTRING_1510") call d_fnc_GreyText, {_this spawn d_fnc_repengineer},[],-1,false];
				player setVariable ["d_has_sfunc_aid", true];
			} else {
				if (player getVariable "d_has_sfunc_aid" && {!(call d_fnc_sfunc)}) then {
					player removeAction d_actionID6;
					player removeAction d_actionID2;
					player setVariable ["d_has_sfunc_aid", false];
				};
			};
		}, 0.56]] call bis_fnc_loop;
	};

	player setVariable ["d_is_engineer",true];
	player setVariable ["d_farp_pos", []];

	if (d_engineerfull == 0 || {d_with_ai} || {d_with_ai_features == 0}) then {
		{_x addAction [(localize "STR_DOM_MISSIONSTRING_513") call d_fnc_BlueText, {_this call d_fnc_restoreeng}]} forEach d_farps;
	};
};

{
	_x addAction [(localize "STR_DOM_MISSIONSTRING_286a")call d_fnc_RedText, {_this call d_fnc_healatmash}, 0, -1, false, false, "", "damage player > 0 && {alive player} && {!(player getVariable 'xr_pluncon')} && {!(player getVariable 'd_isinaction')}"];
} forEach d_mashes;

{
	_farpc = _x getVariable ["d_objcont", []];
	if !(_farpc isEqualTo []) then {
		_trig = _farpc select 0;
		_trig setTriggerActivation ["ANY", "PRESENT", true];
		_trig setTriggerStatements ["(thislist call d_fnc_tchopservice) || {(thislist call d_fnc_tvecservice)} || {(thislist call d_fnc_tjetservice)}", "0 = [thislist] spawn d_fnc_reload", ""];
	};
} forEach d_farps;

// Enemy at base
"enemy_base" setMarkerPosLocal (d_base_array select 0);
"enemy_base" setMarkerDirLocal (d_base_array select 3);
[d_eabase_trig1, [d_base_array select 1, d_base_array select 2, d_base_array select 3, true], [d_enemy_side_trigger, "PRESENT", true], ["'Man' countType thislist > 0 || {'Tank' countType thislist > 0} || {'Car' countType thislist > 0}", "[0] call d_fnc_BaseEnemies;'enemy_base' setMarkerSizeLocal [d_base_array select 1,d_base_array select 2];d_there_are_enemies_atbase = true", "[1] call d_fnc_BaseEnemies;'enemy_base' setMarkerSizeLocal [0,0];d_there_are_enemies_atbase = false"]] call d_fnc_CreateTrigger;
[d_eabase_trig2, [(d_base_array select 1) + 300, (d_base_array select 2) + 300, d_base_array select 3, true], [d_enemy_side_trigger, "PRESENT", true], ["'Man' countType thislist > 0 || {'Tank' countType thislist > 0} || {'Car' countType thislist > 0}", "hint (localize 'STR_DOM_MISSIONSTRING_1409');d_enemies_near_base = true", "d_enemies_near_base = false"]] call d_fnc_CreateTrigger;

if (isSteamMission) exitWith {endMission "LOSER"};

if (d_string_player in d_is_medic) then {
	d_player_is_medic = true;
	player setVariable ["d_medtent", []];
};

if (d_WithJumpFlags == 0) then {d_ParaAtBase = 1};

d_x_loop_end = false;
if (d_WithMHQTeleport == 0) then {
	d_FLAG_BASE addAction [(localize "STR_DOM_MISSIONSTRING_533") call d_fnc_GreyText,{_this call d_fnc_teleportx}];
};
if (d_with_ai || {(d_ParaAtBase == 0)}) then {
	d_FLAG_BASE addaction [(localize "STR_DOM_MISSIONSTRING_296") call d_fnc_GreyText,{_this spawn d_fnc_paraj}];
};

if (d_ParaAtBase == 1) then {
	"d_Teleporter" setMarkerTextLocal (localize "STR_DOM_MISSIONSTRING_534");
};

if (d_with_ranked) then {
	player addEventHandler ["handleHeal", {_this call d_fnc_HandleHeal}];
};

if (isMultiplayer) then {
	0 spawn {
		scriptName "spawn_sendplayerstuff";
		sleep (0.5 + random 2);
		["d_p_varn", [getPlayerUID player,d_string_player]] call d_fnc_NetCallEventCTS;
	};
};

execVM "x_client\x_playernamehud.sqf";

if (d_MissionType != 2) then {
	execFSM "fsms\CampDialog.fsm";
};

if (d_with_ai) then {
	0 spawn {
		scriptName "spawn_withaicheck";
		while {true} do {
			waitUntil {sleep 0.272;alive player};
			if (player != leader (group player) && {!(player getVariable ["xr_pluncon", false])} && {!(d_current_ai_units isEqualTo [])}) then {
				d_current_ai_units = [];
				d_current_ai_num = 0;
			};
			if (player getVariable ["xr_pluncon", false]) then {
				waitUntil {sleep 0.332;!(player getVariable ["xr_pluncon", false]) || {!alive player}};
			};
			sleep 1.212;
		};
	};
};

_primw = primaryWeapon player;
if (_primw != "") then {
	player selectWeapon _primw;
	_muzzles = getArray(configFile/"cfgWeapons"/_primw/"muzzles");
	player selectWeapon (_muzzles select 0);
};

if (d_MissionType != 2) then {
	if (!isNil "d_searchbody" && {!isNull d_searchbody} && {isNil {d_searchbody getVariable "d_search_body"}}) then {
		d_searchbody setVariable ["d_search_id", d_searchbody addAction [localize "STR_DOM_MISSIONSTRING_518", {_this spawn d_fnc_searchbody}]];
	};
};

player setVariable ["d_p_f_b", 0];

d_player_base_trig setTriggerArea [d_base_array select 1, d_base_array select 2, d_base_array select 3, true];
d_player_base_trig setTriggerActivation [d_own_side_trigger, "PRESENT", true];
d_player_base_trig setTriggerStatements["this", "", ""];

d_player_base_trig2 setTriggerArea [25, 25, 0, false];
d_player_base_trig2 setTriggerActivation [d_own_side_trigger, "PRESENT", true];
d_player_base_trig2 setTriggerStatements["this", "", ""];

player addEventHandler ["fired", {_this call d_fnc_playerfiredeh}];

if (d_no_3rd_person == 0) then {
	execFSM "fsms\3rdperson.fsm";
};

d_mark_loc280 = localize "STR_DOM_MISSIONSTRING_280";

__TRACE_1("","d_player_entities")
__TRACE("Creating Marker")
{[_x, [0,0],"ICON","ColorGreen",[0.7,0.7],"",0,d_p_marker] call d_fnc_CreateMarkerLocal} forEach d_player_entities;

if (d_with_ai) then {
	for "_ai" from 2 to 40 do {
		[format ["d_AI_X%1%2", d_string_player, _ai], [0,0],"ICON","ColorGreen",[0.7,0.7],"",0,d_p_marker] call d_fnc_CreateMarkerLocal;
	};
};

0 spawn {
	scriptName "spawn_start_marker";
	sleep 10;
	["itemAdd", ["dom_marker_vecs", {call d_fnc_xmarkervehicles}, nil, nil, {visibleMap || {d_do_ma_update_n} || {visibleGPS}}]] call bis_fnc_loop;

	["itemAdd", ["dom_marker_units", {
		call d_fnc_xmarkerplayers;
		if (d_with_ai) then {
			call d_fnc_xai_markers;
		}
	}, nil, nil, {d_show_player_marker > 0 && {visibleMap || {d_do_ma_update_n} || {visibleGPS}}}]] call bis_fnc_loop;
};

private ["_box","_box_array"];

_box_array = [];

_box_array = d_player_ammobox_pos;

_box = d_the_base_box createVehicleLocal (_box_array select 0);
_box setDir (_box_array select 1);
_box setPos (_box_array select 0);
player reveal _box;
[_box] call d_fnc_weaponcargo;
_box addAction ["<t color='#FF0000'>Virtual Ammobox System (VAS)</t>", "VAS\open.sqf", [], 6, true, true, "", "vehicle _this == _this && _this distance getPos _target < 6"];

d_player_ammobox_pos = nil;

[_box,_box_array] execFSM "fsms\PlayerAmmobox.fsm";

(findDisplay 46) displayAddEventHandler ["MouseZChanged", {_this call d_fnc_MouseWheelRec}];

if (d_WithRevive == 0) then {
	call compile preprocessFileLineNumbers "x_revive.sqf";
};

/*["itemAdd", ["dom_command_menu", {
	call d_fnc_command_menu;
}, 2, "frames", {!isNil "d_commandingMenuCode"}]] call bis_fnc_loop;*/

0 spawn {
	while {true} do {
		sleep 0.2;
		if (!isNil "d_commandingMenuCode") then {
			call d_fnc_command_menu;
		};
	};
};

(findDisplay 46) displayAddEventHandler ["KeyDown", {if (_this select 1 in actionKeys "TeamSwitch" && {alive player} && {!(player getVariable "xr_pluncon")} && {!(_this select 2)} && {!(_this select 3)} && {!(_this select 4)}) then {[0, _this] call d_fnc_KeyDownCommandingMenu; true} else {false}}];
(findDisplay 46) displayAddEventHandler ["KeyUp", {if (_this select 1 in actionKeys "TeamSwitch"&& {!(_this select 2)} && {!(_this select 3)} && {!(_this select 4)}) then {[1, _this] call d_fnc_KeyDownCommandingMenu; true} else {false}}];

// currently the only way to disable slingload assistant and rope action for sling loadling.
// sadly yet another Arma bug is not fixed, therefore inputAction is also needed... http://feedback.arma3.com/view.php?id=20845
(findDisplay 46) displayAddEventHandler ["KeyDown", {(vehicle player isKindOf "Helicopter" && {_this select 1 in actionKeys "HeliRopeAction" || {_this select 1 in actionKeys "HeliSlingLoadManager"} || {inputAction "HeliRopeAction" > 0} || {inputAction "HeliSlingLoadManager" > 0}})}];

["itemAdd", ["dom_pl_in_vec_x", {
	if (!d_player_in_vec && {vehicle player != player} && {alive player} && {!(player getVariable "xr_pluncon")}) then {
		call d_fnc_vehicleScripts;
	} else {
		if (d_player_in_vec && {vehicle player == player || {!alive player} || {player getVariable "xr_pluncon"}}) then {
			d_player_in_vec = false;
		};
	};
}, 0.49]] call bis_fnc_loop;

player setVariable ["d_p_isadmin", false];
if (d_AutoKickTime == 0 || {d_with_ranked} || {d_MissionType == 2}) then {
	d_clientScriptsAr set [1, true];
};

["itemAdd", ["dom_cl_scripts_x", {call d_fnc_startClientScripts}, 0.6]] call bis_fnc_loop;

if (!isNil "d_base_runway_marker_trig") then {
	_msize = markerSize "d_runwaymarker";
	[d_base_runway_marker_trig, [_msize select 0, _msize select 1, markerDir "d_runwaymarker", true], ["ANY", "PRESENT", true], ["!((thislist unitsBelowHeight 1) isEqualTo [])", "'d_runwaymarker' setMarkerColorLocal 'ColorRed'", "'d_runwaymarker' setMarkerColorLocal 'ColorGreen'"]] call d_fnc_CreateTrigger;
};

player call d_fnc_removefak;

if (d_without_nvg == 1) then {
	if !(player call d_fnc_hasnvgoggles) then {
		player linkItem (switch (d_player_side) do {
			case opfor: {"NVGoggles_OPFOR"};
			case independent: {"NVGoggles_INDEP"};
			default {"NVGoggles"};
		});
	};
} else {
	player call d_fnc_removeNVGoggles;
	execFSM "fsms\RemoveGoogles.fsm";
};

_bino = binocular player;
if (d_string_player in d_can_use_artillery || {d_string_player in d_can_mark_artillery}) then {
	if (_bino != "LaserDesignator") then {
		if (_bino != "") then {
			player removeWeapon _bino;
		};
		player addWeapon "LaserDesignator";
	};
	if !("Laserbatteries" in magazines player) then {
		player addMagazine ["Laserbatteries", 1];
	};
} else {
	if (_bino == "") then {
		player addWeapon "Binocular";
	};
};
if !("ItemGPS" in (assignedItems player)) then {
	player linkItem "ItemGPS";
};

call d_fnc_save_respawngear;

if (sunOrMoon < 0.99 && {d_without_nvg == 1}) then {player action ["NVGoggles", player]};

0 spawn d_fnc_nostreaming;

0 spawn {
	scriptName "spawn_client_clean_crater";
	private "_craters";
	while {true} do {
		sleep (60 + random 60);
		_craters = allMissionObjects "CraterLong" + allMissionObjects "CraterLong_small";
		{
			deleteVehicle _x;
			sleep 0.212;
		} forEach _craters;
		_craters = nil;
	};
};

for "_i" from 0 to 30 do {
	_vvx = missionNamespace getVariable format ["d_artyvec_%1", _i];
	if (!isNil "_vvx") then {
		d_ao_arty_vecs pushBack _vvx;
		d_areArtyVecsAvailable = true;
	};
};

if (d_with_ai || {d_with_ai_features == 0} || {d_string_player in d_can_use_artillery} || {d_string_player in d_can_mark_artillery}) then {
	player setVariable ["d_ld_action", player addAction [(localize "STR_DOM_MISSIONSTRING_1520") call d_fnc_RedText, {_this call d_fnc_mark_artillery} , 0, 9, true, false, "", "alive player && {!(player getVariable ['xr_pluncon', false])} && {!(player getVariable ['d_isinaction', false])} && {!d_player_in_vec} && {currentWeapon  player == 'LaserDesignator'} && {cameraView == 'GUNNER'} && {!isNull (laserTarget player)}"]];
};

if (isMultiplayer) then {
	execVM "x_client\x_intro.sqf";
} else {
	{if (_x != player) then {_x enableSimulation false}} forEach switchableUnits;
};

player addEventhandler["InventoryOpened", {_this call d_fnc_inventoryopened}];

0 spawn {
	// no event for it :(
	disableSerialization;
	while {true} do {
		waitUntil {sleep 0.11;!isNull (uiNamespace getVariable "RscDisplayArsenal")};
		_usenvg = sunOrMoon < 0.9;
		if (_usenvg) then {camUseNVG true};
		_disp = uiNamespace getVariable "RscDisplayArsenal";
		sleep 0.1;
		(_disp displayCtrl 44150) ctrlEnable false; // random
		(_disp displayCtrl 44148) ctrlEnable false; // export
		(_disp displayCtrl 44149) ctrlEnable false; // import
		(_disp displayCtrl 44151) ctrlEnable false; // hide
		if (d_with_ranked) then {
			(_disp displayCtrl 44147) ctrlEnable false; // Load
			(_disp displayCtrl 44146) ctrlEnable false; // Save
		};
		waitUntil {sleep 0.21;isNull (uiNamespace getVariable "RscDisplayArsenal")};
		call d_fnc_save_respawngear;
		if (_usenvg) then {camUseNVG false};
		if (d_with_ranked) then {
			call d_fnc_store_rwitems;
		};
	};
};

0 spawn {
	waitUntil {!d_still_in_intro};
	// make one frame?
	disableSerialization;
	7754 cutRsc ["d_FatiguePbar", "PLAIN"];
	private ["_fatbaron", "_ctrl"];
	_fatbaron = true;
	_ctrl = (uiNamespace getVariable "d_FatiguePbar") displayCtrl 10;
	while {true} do {
		if (alive player && {!(player getVariable ["xr_pluncon", false])}) then {
			if (!_fatbaron) then {
				7754 cutRsc ["d_FatiguePbar", "PLAIN"];
				_ctrl = (uiNamespace getVariable "d_FatiguePbar") displayCtrl 10;
				_fatbaron = true;
			};
			_ctrl progressSetPosition (getFatigue player);
		} else {
			7754 cutRsc ["d_Empty", "PLAIN"];
			_fatbaron = false;
			waitUntil {sleep 0.21; alive player && {!(player getVariable ["xr_pluncon", false])}};
		};
		sleep 1;
	};
};

player addEventhandler ["HandleRating", {
	if (_this select 1 < 0) then {0} else {_this select 1}
}];

d_pisadminp = false;
(findDisplay 46) displayAddEventHandler ["MouseMoving", {call d_fnc_SCACheck}];
(findDisplay 46) displayAddEventHandler ["MouseHolding", {call d_fnc_SCACheck}];

["Preload"] call bis_fnc_arsenal;

diag_log [diag_frameno, diag_ticktime, time, "Dom x_setupplayer.sqf processed"];
