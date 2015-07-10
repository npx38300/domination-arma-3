// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m0.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_0" call d_fnc_smmapos; // radar tower Aristi
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_822a";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_823";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	_vehicle = createVehicle [d_illum_tower, _poss, [], 0, "NONE"];
	_vehicle setPos _poss;
	_vehicle setVectorUp [0,0,1];
	_vehicle call d_fnc_addKilledEHSM;
	sleep 3.21;
	["specops", 2, "basic", 3, _poss,200,true] spawn d_fnc_CreateInf;
	d_x_sm_vec_rem_ar pushBack _vehicle;
};
