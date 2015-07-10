// #define __DEBUG__
// by Xeno
#define THIS_FILE "x_m37.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_37" call d_fnc_smmapos; // index: 37,   Radar near Eginio
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1503";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_1504";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	_vehicle = createVehicle [d_sm_small_radar, _poss, [], 0, "NONE"];
	_vehicle call d_fnc_addKilledEHSM;
	_vehicle setDir 270;
	_vehicle setPos _poss;
	_vehicle setVectorUp [0,0,1];
	sleep 2.132;
	["specops", 1, "basic", 1, _poss,50,true] spawn d_fnc_CreateInf;
	sleep 2.234;
	["aa", 1, "tracked_apc", 1, "tank", 1, _poss,1,60,true] spawn d_fnc_CreateArmor;
	d_x_sm_vec_rem_ar pushBack _vehicle;
};
