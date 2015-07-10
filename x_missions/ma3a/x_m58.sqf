// by Xeno
// #define __DEBUG__
#define THIS_FILE "x_m58.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_58" call d_fnc_smmapos; //index:58 Find and eliminate the lonewolf sniper near Orino
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1546";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_1545";
};

if (call d_fnc_checkSHC) then {
	private ["_poss", "_ogroup", "_bpos", "_leadero"];
	_poss = d_x_sm_pos select 0;
	_newpos = [_poss, 150] call d_fnc_GetRanPointCircle;
	_ogroup = [d_side_enemy] call d_fnc_creategroup;
	_sm_vehicle = _ogroup createUnit [d_sniper, _newpos, [], 0, "FORM"];
	_sm_vehicle setPos _newpos;
	_sm_vehicle call d_fnc_removeNVGoggles;
	_sm_vehicle call d_fnc_removefak;
	_sm_vehicle addEventHandler ["killed", {_this call d_fnc_KilledSMTargetNormal}];
	d_x_sm_rem_ar pushBack _sm_vehicle;
	[_ogroup, 1] call d_fnc_setGState;
	sleep 2.123;
	["specops", 3, "basic", 0, _newpos, 0,true] call d_fnc_CreateInf;
	sleep 2.123;
	_leadero = leader _ogroup;
	_leadero setRank "COLONEL";
	_ogroup allowFleeing 0;
	_ogroup setbehaviour "CARELESS";
	_leadero disableAI "DOWN";
};
