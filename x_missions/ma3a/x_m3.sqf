//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m3.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_3" call d_fnc_smmapos; //  steal tank prototype, Ochrolimni, array 2 and 3 = infantry and armor positions
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_852";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_769";
};

if (call d_fnc_checkSHC) then {
	private ["_vehicle", "_poss"];
	_poss = d_x_sm_pos select 0;
	_vehicle = objNull;
	_vehicle = createVehicle [d_sm_tank, _poss, [], 0, "NONE"];
	_vehicle setDir  markerDir "d_sm_3";
	_vehicle setPos _poss;
	sleep 2.123;
	["specops", 1, "basic", 1, d_x_sm_pos select 1, 250, true] spawn d_fnc_CreateInf;
	sleep 2.321;
	["aa", 1, "tracked_apc", 1, "tank", 0, d_x_sm_pos select 2, 1, 400, true] spawn d_fnc_CreateArmor;
	[_vehicle] spawn d_fnc_sidesteal;
	_vehicle addMPEventHandler ["MPKilled", {if (isServer) then {[_this select 0, _this select 1, 2] call d_fnc_sidempkilled}}];
	_vehicle setDamage 0;
};
