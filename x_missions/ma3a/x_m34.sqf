//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m34.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_34" call d_fnc_smmapos; // index: 34, Fuel Storage at Factory near Kore
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1499";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_1500";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	//_pos_other = d_x_sm_pos select 1;
	_vehicle = createVehicle [d_sm_land_tanksmall, _poss, [], 0, "NONE"];
	_vehicle call d_fnc_addKilledEHSM;
	_vehicle setDir 270;
	_vehicle setPos _poss;
	_vehicle setVectorUp [0,0,1];
	sleep 2.132;
	["specops", 1, "basic", 1, _poss,50,true] spawn d_fnc_CreateInf;
	sleep 2.234;
	["aa", 1, "tracked_apc", 1, "tank", 1, _poss,1,100,true] spawn d_fnc_CreateArmor;
	d_x_sm_vec_rem_ar pushBack _vehicle;
};
