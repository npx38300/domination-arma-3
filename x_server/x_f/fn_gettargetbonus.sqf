// by Xeno
#define THIS_FILE "fn_gettargetbonus.sqf"
#include "x_setup.sqf"
private ["_vehicle", "_endpos", "_dir", "_cur_tar_obj", "_vectypetouse"];

if (!isServer) exitWith {};

_cur_tar_obj = missionNamespace getVariable format ["d_target_%1", d_current_target_index];

sleep 1.012;

_vectypetouse = "";

if (!isNil "_cur_tar_obj" && {!isNull _cur_tar_obj}) then {
	_vectypesv = _cur_tar_obj getVariable "d_bonusvec";
	if (!isNil "_vectypesv") then {
		_vectypetouse = _vectypesv;
	};
};
if (_vectypetouse == "") then {
	_vectypetouse = d_mt_bonus_vehicle_array select (d_mt_bonus_vehicle_array call d_fnc_RandomFloorArray);
};
_vehicle = createVehicle [_vectypetouse, d_bonus_create_pos, [], 0, "NONE"];
/*if (getNumber(configFile/"CfgVehicles"/_vectypetouse/"isUav") == 0) then {
	_vehicle setVehicleAmmo 0;
	_vehicle setFuel 0.1;
} else {
	createVehicleCrew _vehicle;
};*/
if (getNumber(configFile/"CfgVehicles"/_vectypetouse/"isUav") != 0) then {
	createVehicleCrew _vehicle;
};
_endpos = [];
_dir = 0;
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

d_target_clear = true; publicVariable "d_target_clear";
_cur_tgt_name = (d_target_names select d_current_target_index) select 1;
["d_s_mc_g", ["d_" + _cur_tgt_name + "_dommtm", "ColorGreen"]] call d_fnc_NetCallEventCTS;
["d_target_clear", _vectypetouse] call d_fnc_NetCallEventToClients;
d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Captured",["1","",_cur_tgt_name,[_cur_tgt_name]],"SIDE"];
