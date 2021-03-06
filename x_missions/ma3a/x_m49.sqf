//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m49.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_49" call d_fnc_smmapos; // index: 49,   Artillery base
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1448";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_810";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos select 0] spawn d_fnc_sidearti;
};
