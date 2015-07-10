//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m48.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_48" call d_fnc_smmapos; // index: 48,   Officer on the south island
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_868";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_806";
};

if (call d_fnc_checkSHC) then {
	private ["_ogroup", "_poss", "_leadero"];
	_poss = d_x_sm_pos select 0;
	sleep 2.111;
	_ogroup = [d_side_enemy] call d_fnc_creategroup;
	_sm_vehicle = _ogroup createUnit [d_soldier_officer, _poss, [], 0, "FORM"];
	_sm_vehicle call d_fnc_removeNVGoggles;
	_sm_vehicle call d_fnc_removefak;
	_sm_vehicle addEventHandler ["killed", {_this call d_fnc_KilledSMTarget500}];
	d_x_sm_rem_ar pushBack _sm_vehicle;
	removeAllWeapons _sm_vehicle;
	[_ogroup, 1] call d_fnc_setGState;
	sleep 2.123;
	["specops", 3, "basic", 2, _poss, 200,true] spawn d_fnc_CreateInf;
	sleep 2.123;
	["aa", 1, "tracked_apc", 1, "tank", 1, _poss,1,350,true] spawn d_fnc_CreateArmor;
	sleep 2.123;
	_leadero = leader _ogroup;
	_leadero setRank "COLONEL";
	_ogroup allowFleeing 0;
	_ogroup setbehaviour "AWARE";
	_leadero disableAI "MOVE";
	[_sm_vehicle] spawn d_fnc_sidearrest;
};
