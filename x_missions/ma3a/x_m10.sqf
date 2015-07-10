//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m10.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_10" call d_fnc_smmapos; // index: 10,   Artillery at top of mount Agios Minas
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_825";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_731";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	_vehicle = createVehicle [d_sm_arty, _poss, [], 0, "NONE"];
	_vehicle setPos _poss;
	_vehicle addEventHandler ["killed", {_this call d_fnc_KilledSMTargetNormal; (_this select 0) removeAllEventHandlers "killed"}];
	_vehicle lock true;
	d_x_sm_vec_rem_ar pushBack _vehicle;
	sleep 2.21;
	["specops", 1, "basic", 2, _poss,0] spawn d_fnc_CreateInf;
	sleep 2.045;
	["aa", 1, "tracked_apc", 1, "tank", 0, d_x_sm_pos select 1, 1, 0] spawn d_fnc_CreateArmor;
};
