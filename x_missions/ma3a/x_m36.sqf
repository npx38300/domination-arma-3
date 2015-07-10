//#define __DEBUG___
// by Xeno
#define THIS_FILE "x_m36.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_36" call d_fnc_smmapos; // index: 36,   Boat making facility near Iremi Bay
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1501";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_1502";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	_vehicle = createVehicle [d_sm_land_factory, _poss, [], 0, "NONE"];
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
