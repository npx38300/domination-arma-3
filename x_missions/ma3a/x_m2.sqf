//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m2.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_2" call d_fnc_smmapos;
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_839";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_750";
};

if (call d_fnc_checkSHC) then {
	private ["_poss", "_vehicle"];
	_poss = d_x_sm_pos select 0;
	_vehicle = createVehicle [d_sm_plane, _poss, [], 0, "NONE"];
	_vehicle setDir (markerDir "d_sm_2");
	_vehicle setPos _poss;
	sleep 2.123;
	["specops", 1, "basic", 1, _poss, 300, true] spawn d_fnc_CreateInf;
	sleep 2.221;
	["aa", 1, "tracked_apc", 1, "tank", 1, d_x_sm_pos select 1, 1, 400, true] spawn d_fnc_CreateArmor;
	[_vehicle] spawn d_fnc_sidesteal;
	_vehicle addMPEventHandler ["MPKilled", {if (isServer) then {[_this select 0, _this select 1, 1] call d_fnc_sidempkilled}}];
	_vehicle setDamage 0;
};
