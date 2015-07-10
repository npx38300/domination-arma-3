//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m17.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_17" call d_fnc_smmapos; // index: 17,   Officer in Nidasos
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_836";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_729";
};

if (call d_fnc_checkSHC) then {
	private ["_officer", "_poss", "_fortress", "_newgroup", "_leader"];
	_officer = d_soldier_officer;
	_poss = d_x_sm_pos select 0;
	["aa", 1, "tracked_apc", 1, "tank", 1, d_x_sm_pos select 1, 1, 400, true] spawn d_fnc_CreateArmor;
	sleep 2.123;
	["specops", 2, "basic", 1, _poss,200,true] spawn d_fnc_CreateInf;
	sleep 2.111;
	_fortress = createVehicle [d_sm_fortress, _poss, [], 0, "NONE"];
	_fortress setPos _poss;
	d_x_sm_vec_rem_ar pushBack _fortress;
	sleep 2.123;
	_newgroup = [d_side_enemy] call d_fnc_creategroup;
	_sm_vehicle = _newgroup createUnit [_officer, _poss, [], 0, "FORM"];
	_sm_vehicle call d_fnc_removeNVGoggles;
	_sm_vehicle call d_fnc_removefak;
	_sm_vehicle addEventHandler ["killed", {_this call d_fnc_KilledSMTargetNormal}];
	d_x_sm_rem_ar pushBack _sm_vehicle;
	[_newgroup, 1] call d_fnc_setGState;
	sleep 2.123;
	_sm_vehicle setPos (getPosATL _fortress);
	_leader = leader _newgroup;
	_leader setRank "COLONEL";
	_newgroup allowFleeing 0;
	_newgroup setbehaviour "AWARE";
	_leader disableAI "MOVE";
};
