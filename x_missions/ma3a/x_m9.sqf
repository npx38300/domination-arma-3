//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m9.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_9" call d_fnc_smmapos; // index: 9,   Helicopter Prototype near Selakano
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_878";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_821";
};

if (call d_fnc_checkSHC) then {
	private ["_poss", "_vehicle"];
	_poss = d_x_sm_pos select 0;
	_pos_other = d_x_sm_pos select 1;
	if ((floor random 2) == 1) then {_poss = d_x_sm_pos select 3};
	_vehicle = createVehicle [d_sm_chopper, _poss, [], 0, "NONE"];
	_vehicle setDir (markerDir "d_sm_9");
	_vehicle setPos _poss;
	_vehicle addEventHandler ["killed", {_this call d_fnc_KilledSMTargetNormal}];
	_vehicle lock true;
	d_x_sm_vec_rem_ar pushBack _vehicle;
	sleep 2.123;
	["specops", 1, "basic", 2, _poss,200,true] spawn d_fnc_CreateInf;
	sleep 2.111;
	["aa", 1, "tracked_apc", 1, "tank", 0, d_x_sm_pos select 2, 1, 400, true] spawn d_fnc_CreateArmor;
};
