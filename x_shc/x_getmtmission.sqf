// by Xeno
#define THIS_FILE "x_getmtmission.sqf"
#include "x_setup.sqf"

#define __getPos \
_poss = [_tgt_ar select 0, _tgt_ar select 2] call d_fnc_GetRanPointCircleBig;\
while {_poss isEqualTo []} do {\
	_poss = [_tgt_ar select 0, _tgt_ar select 2] call d_fnc_GetRanPointCircleBig;\
	sleep 0.01;\
}

#define __specops \
_newgroup = [d_side_enemy] call d_fnc_creategroup;\
_unit_array = [#specops, d_enemy_side] call d_fnc_getunitlist;\
[_poss, _unit_array select 0, _newgroup] spawn d_fnc_makemgroup;\
sleep 1.0112;\
_newgroup allowFleeing 0;\
_newgroup setVariable ["d_defend", true]; \
[_newgroup, _poss] spawn d_fnc_taskDefend; \
[_newgroup, 1] call d_fnc_setGState;

#define __vkilled(ktype) _vehicle addEventHandler [#killed, {_this pushBack #ktype; _this call d_fnc_MTSMTargetKilled}]

private ["_man","_newgroup","_poss","_unit_array","_vehicle","_wp_array","_truck","_the_officer","_sec_kind","_fixor"];
if !(call d_fnc_checkSHC) exitWith {};

_fixor = {
	scriptName "spawn_x_getmtmission_fixor";
	private ["_unit", "_list","_curidx"];
	_unit = [_this, 0] call BIS_fnc_param;
	_curidx = [_this, 1] call BIS_fnc_param;
	sleep 10;
	while {true} do {
		if (!alive _unit || {isNull _unit}) exitWith {};
		sleep 0.01;
		_list = list d_current_trigger;
		if (d_campscaptured == d_sum_camps && {("Car" countType _list <= d_car_count_for_target_clear)} && {("Tank" countType _list <= d_tank_count_for_target_clear)} && {("CAManBase" countType _list <= d_man_count_for_target_clear)}) exitWith {};
		
		sleep 3.219;
	};
	if (alive _unit) then {
		sleep 240 + random 60;
		if (alive _unit && _curidx == d_current_target_index) then {
			_unit setDamage 1;
			d_side_main_done = true;
			if (!isServer) then {
				["d_sSetVar", ["d_side_main_done", true]] call d_fnc_NetCallEventCTS;
			};
		} else {
			if (isNull _unit && {!d_side_main_done} && {_curidx == d_current_target_index}) then {
				d_side_main_done = true;
				if (!isServer) then {
					["d_sSetVar", ["d_side_main_done", true]] call d_fnc_NetCallEventCTS;
				};
			};
		};
	} else {
		if (isNull _unit && {!d_side_main_done} && {_curidx == d_current_target_index}) then {
			d_side_main_done = true;
			if (!isServer) then {
				["d_sSetVar", ["d_side_main_done", true]] call d_fnc_NetCallEventCTS;
			};
		};
	};
};

_wp_array = _this;

sleep 3.120;
_poss = _wp_array select ((count _wp_array) call d_fnc_RandomFloor);

_sec_kind = (floor (random 10)) + 1;
_tgt_ar = d_target_names select d_current_target_index;
_cur_tgt_name = _tgt_ar select 1;

switch (_sec_kind) do {
	case 1: {
		_newgroup = [d_side_enemy] call d_fnc_creategroup;
		_the_officer = switch (d_enemy_side) do {
			case "OPFOR": {"O_officer_F"};
			case "BLUFOR": {"B_officer_F"};
			case "INDEPENDENT": {"I_Story_Colonel_F"};
		};
		_vehicle = _newgroup createUnit [_the_officer, _poss, [], 0, "FORM"];
		_vehicle call d_fnc_removeNVGoggles;
		_vehicle call d_fnc_removefak;
		_svec = sizeOf _the_officer;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setPos _poss;
		_vehicle setRank "COLONEL";
		_vehicle setSkill 0.3;
		_vehicle disableAI "MOVE";
		[_newgroup, 1] call d_fnc_setGState;
		[_vehicle, d_current_target_index] spawn _fixor;
		_sum = 0;
		{if (_x == 1) then {_sum = _sum + 1}} forEach d_searchintel;
		if (_sum < count d_searchintel) then {
			d_intel_unit = _vehicle;
			d_searchbody = _vehicle; publicVariable "d_searchbody";
			["d_s_b_client"] call d_fnc_NetCallEventToClients;
		} else {
			if (!isNull d_searchbody) then {
				d_searchbody = objNull; publicVariable "d_searchbody";
			};
		};
		sleep 0.1;
		__vkilled(gov_dead);
		if (d_with_ai && {d_with_ranked}) then {
			_vehicle addEventHandler ["MPKilled", {if (isServer) then {[1, _this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllEventHandlers "MPKilled"}}];
		};
		sleep 1.0112;
		__specops;
	};
	case 2: {
		__getPos;
		_ctype = "Land_Radar_Small_F";
		_vehicle = createVehicle [_ctype, _poss, [], 0, "NONE"];
		_svec = sizeOf _ctype;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setPos _poss;
		[_vehicle] execFSM "fsms\XRemoveVehiExtra.fsm";
		__vkilled(radar_down);
		[_vehicle, d_current_target_index] spawn _fixor;
		sleep 1.0112;
		__specops;
	};
	case 3: {
		__getPos;
		_truck = switch (d_enemy_side) do {
			case "OPFOR": {"O_Truck_02_Ammo_F"};
			case "BLUFOR": {"B_Truck_01_ammo_F"};
			case "INDEPENDENT": {"I_Truck_02_ammo_F"};
		};
		_vehicle = createVehicle [_truck, _poss, [], 0, "NONE"];
		_svec = sizeOf _truck;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setDir (floor random 360);
		_vehicle setPos _poss;
		_vehicle lock true;
		_vehicle addEventHandler ["killed", {
			_this pushBack "ammo_down";
			_this call d_fnc_MTSMTargetKilled;
			_this call d_fnc_handleDeadVec;
		}];
		[_vehicle, d_current_target_index] spawn _fixor;
		sleep 1.0112;
		__specops;
	};
	case 4: {
		_truck = switch (d_enemy_side) do {
			case "OPFOR": {"O_Truck_02_medical_F"};
			case "BLUFOR": {"B_Truck_01_medical_F"};
			case "INDEPENDENT": {"I_Truck_02_medical_F"};
		};
		_vehicle = createVehicle [_truck, _poss, [], 0, "NONE"];
		_svec = sizeOf _truck;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setDir (floor random 360);
		_vehicle setPos _poss;
		_vehicle lock true;
		_vehicle addEventHandler ["killed", {
			_this pushBack "apc_down";
			_this call d_fnc_MTSMTargetKilled;
			_this call d_fnc_handleDeadVec;
		}];
		[_vehicle, d_current_target_index] spawn _fixor;
		sleep 1.0112;
		__specops;
	};
	case 5: {
		__getPos;
		_vehicle = createVehicle [d_enemy_hq, _poss, [], 0, "NONE"];
		_svec = sizeOf d_enemy_hq;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setDir (floor random 360);
		_vehicle setPos _poss;
		_vehicle lock true;
		[_vehicle] execFSM "fsms\XRemoveVehiExtra.fsm";
		__vkilled(hq_down);
		[_vehicle, d_current_target_index] spawn _fixor;
		sleep 1.0112;
		__specops;
	};
	case 6: {
		__getPos;
		_fact = "Land_dp_transformer_F";
		_vehicle = createVehicle [_fact, _poss, [], 0, "NONE"];
		_svec = sizeOf _fact;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setDir (floor random 360);
		_vehicle setPos _poss;
		[_vehicle] execFSM "fsms\XRemoveVehiExtra.fsm";
		__vkilled(light_down);
		[_vehicle, d_current_target_index] spawn _fixor;
		sleep 1.0112;
		__specops;
	};
	case 7: {
		__getPos;
		/*_fact = switch (d_enemy_side) do {
			case "OPFOR": {"Land_spp_Transformer_F"};
			case "BLUFOR": {"Land_spp_Transformer_F"};
			case "INDEPENDENT": {"Land_spp_Transformer_F"};
		};*/
		_fact = "Land_spp_Transformer_F";
		_vehicle = createVehicle [_fact, _poss, [], 0, "NONE"];
		_svec = sizeOf _fact;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setDir (floor random 360);
		_vehicle setPos _poss;
		[_vehicle] execFSM "fsms\XRemoveVehiExtra.fsm";
		__vkilled(heavy_down);
		[_vehicle, d_current_target_index] spawn _fixor;
		sleep 1.0112;
		__specops;
	};
	case 8: {
		__getPos;
		_vehicle = createVehicle [d_air_radar, _poss, [], 0, "NONE"];
		_svec = sizeOf d_air_radar;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setDir (floor random 360);
		_vehicle setPos _poss;
		[_vehicle] execFSM "fsms\XRemoveVehiExtra.fsm";
		__vkilled(airrad_down);
		[_vehicle, d_current_target_index] spawn _fixor;
		sleep 1.0112;
		__specops;
	};
	case 9: {
		_newgroup = [d_side_enemy] call d_fnc_creategroup;
		_ctype = "C_man_polo_6_F";
		_vehicle = _newgroup createUnit [_ctype, _poss, [], 0, "FORM"];
		_vehicle call d_fnc_removeNVGoggles;
		_vehicle call d_fnc_removefak;
		_svec = sizeOf _ctype;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setPos _poss;
		_vehicle setRank "COLONEL";
		_vehicle setSkill 0.3;
		_vehicle disableAI "MOVE";
		[_newgroup, 1] call d_fnc_setGState;
		[_vehicle, d_current_target_index] spawn _fixor;
		_vehicle addMagazines ["16Rnd_9x21_Mag", 2];
		_vehicle addWeapon "hgun_Rook40_F";
		_sum = 0;
		{if (_x == 1) then {_sum = _sum + 1}} forEach d_searchintel;
		if (_sum < count d_searchintel) then {
			d_intel_unit = _vehicle;
			d_searchbody = _vehicle; publicVariable "d_searchbody";
			["d_s_b_client"] call d_fnc_NetCallEventToClients;
		} else {
			if (!isNull d_searchbody) then {
				d_searchbody = objNull; publicVariable "d_searchbody";
			};
		};
		sleep 0.1;
		__vkilled(lopo_dead);
		if (d_with_ai && {d_with_ranked}) then {
			_vehicle addEventHandler ["MPKilled", {if (isServer) then {[1, _this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllEventHandlers "MPKilled"}}];
		};
		sleep 1.0112;
		__specops;
	};
	case 10: {
		_newgroup = [d_side_enemy] call d_fnc_creategroup;
		_ctype = "C_man_1_3_F";
		_vehicle = _newgroup createUnit [_ctype, _poss, [], 0, "FORM"];
		_vehicle call d_fnc_removeNVGoggles;
		_vehicle call d_fnc_removefak;
		_svec = sizeOf _ctype;
		_isFlat = (getPosATL _vehicle) isFlatEmpty [_svec / 2, 150, 0.7, _svec, 0, false, _vehicle];
		if (count _isFlat > 1) then {
			_isFlat set [2,0];
			if (_poss distance _isFlat < 100) then {
				_poss = _isFlat;
			};
		};
		_vehicle setPos _poss;
		_vehicle setRank "COLONEL";
		_vehicle setSkill 0.3;
		[_newgroup, 1] call d_fnc_setGState;
		[_vehicle, d_current_target_index] spawn _fixor;
		_vehicle disableAI "MOVE";
		_vehicle addMagazines ["16Rnd_9x21_Mag", 2];
		_vehicle addWeapon "hgun_Rook40_F";
		_sum = 0;
		{if (_x == 1) then {_sum = _sum + 1}} forEach d_searchintel;
		if (_sum < count d_searchintel) then {
			d_intel_unit = _vehicle;
			d_searchbody = _vehicle; publicVariable "d_searchbody";
			["d_s_b_client"] call d_fnc_NetCallEventToClients;
		} else {
			if (!isNull d_searchbody) then {
				d_searchbody = objNull; publicVariable "d_searchbody";
			};
		};
		sleep 0.1;
		__vkilled(dealer_dead);
		if (d_with_ai && {d_with_ranked}) then {
			_vehicle addEventHandler ["MPKilled", {if (isServer) then {[1, _this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllEventHandlers "MPKilled"}}];
		};
		sleep 1.0112;
		__specops;
	};
};

d_sec_kind = _sec_kind; publicVariable "d_sec_kind";
_s = "";
if (d_current_target_index != -1) then {
	_s = (switch (_sec_kind) do {
		case 1: {
			format [localize "STR_DOM_MISSIONSTRING_891", _cur_tgt_name]
		};
		case 2: {
			format [localize "STR_DOM_MISSIONSTRING_893", _cur_tgt_name]
		};
		case 3: {
			format [localize "STR_DOM_MISSIONSTRING_894", _cur_tgt_name]
		};
		case 4: {
			format [localize "STR_DOM_MISSIONSTRING_896", _cur_tgt_name]
		};
		case 5: {
			format [localize "STR_DOM_MISSIONSTRING_898", _cur_tgt_name]
		};
		case 6: {
			format [localize "STR_DOM_MISSIONSTRING_899", _cur_tgt_name]
		};
		case 7: {
			format [localize "STR_DOM_MISSIONSTRING_900", _cur_tgt_name]
		};
		case 8: {
			format [localize "STR_DOM_MISSIONSTRING_902", _cur_tgt_name]
		};
		case 9: {
			format [localize "STR_DOM_MISSIONSTRING_903", _cur_tgt_name]
		};
		case 10: {
			format [localize "STR_DOM_MISSIONSTRING_904", _cur_tgt_name]
		};
	});
} else {
	_s = localize "STR_DOM_MISSIONSTRING_905";
};
["d_kbmsg", [18, _s]] call d_fnc_NetCallEventCTS;
