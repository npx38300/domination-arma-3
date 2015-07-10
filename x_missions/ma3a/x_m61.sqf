// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m61.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_61" call d_fnc_smmapos; // index:61 steal Ifrit GMG prototype, At the Mine South of Charkia, array 2 and 3 = infantry and armor positions
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1550";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_1551";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	_vehicle = createVehicle [d_sm_HunterGMG, _poss, [], 0, "NONE"];
	_vehicle setDir  markerDir "d_sm_61";
	_vehicle setPos _poss;
	sleep 2.123;
	["specops", 4, "basic", 4, d_x_sm_pos select 1, 150, true] spawn d_fnc_CreateInf;
	sleep 2.321;
	["aa", 3, "tracked_apc", 1, "tank", 0, d_x_sm_pos select 2, 1, 200, true] spawn d_fnc_CreateArmor;
	[_vehicle] spawn d_fnc_sidesteal;
	_vehicle addMPEventHandler ["MPKilled", {if (isServer) then {[_this select 0, _this select 1, 2] call d_fnc_sidempkilled}}];
	_vehicle setDamage 0;
};
