//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m30.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_30" call d_fnc_smmapos; // index: 30,   Tank depot Gatolia
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_854";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_767";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos, [markerDir "d_sm_30_1",markerDir "d_sm_30_2",markerDir "d_sm_30_3",markerDir "d_sm_30_4",markerDir "d_sm_30_5",markerDir "d_sm_30_6"]] spawn d_fnc_sidetanks;
};
