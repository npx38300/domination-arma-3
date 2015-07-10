//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m8.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_8" call d_fnc_smmapos; // index: 8,   Radio tower on Makrynisi
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_876";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_823";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	_vehicle = createVehicle [d_illum_tower, _poss, [], 0, "NONE"];
	_vehicle setPos _poss;
	_vehicle setVectorUp [0,0,1];
	_vehicle call d_fnc_addKilledEHSM;
	sleep 2.22;
	["specops", 1, "basic", 2, _poss,0] spawn d_fnc_CreateInf;
};
