//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_m1.sqf"
#include "x_setup.sqf"

d_x_sm_pos = "d_sm_1" call d_fnc_smmapos; // Officer, Camp near Frini, second array = pos aa
d_x_sm_type = "normal"; // "convoy"

if (!isDedicated && {!d_IS_HC_CLIENT}) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_824";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_729";
};

if (call d_fnc_checkSHC) then {
	private ["_officer", "_fortress", "_poss", "_ogroup", "_bpos", "_leadero"];
	_officer = d_soldier_officer;
	_poss = d_x_sm_pos select 0;
	["aa", 1, "", 0, "", 0, d_x_sm_pos select 1, 1, 0, false] spawn d_fnc_CreateArmor;
	sleep 2.123;
	_fortress = createVehicle [d_sm_fortress, _poss, [], 0, "NONE"];
	_fortress setDir (markerDir "d_sm_1");
	_fortress setPos _poss;
	d_x_sm_vec_rem_ar pushBack _fortress;
	sleep 2.123;
	_ogroup = [d_side_enemy] call d_fnc_creategroup;
	_sm_vehicle = _ogroup createUnit [_officer, _poss, [], 0, "FORM"];
	_sm_vehicle call d_fnc_removeNVGoggles;
	_sm_vehicle call d_fnc_removefak;
	_sm_vehicle addEventHandler ["killed", {_this call d_fnc_KilledSMTargetNormal}];
	d_x_sm_rem_ar pushBack _sm_vehicle;
	[_sm_vehicle, 1] call d_fnc_setGState;
	sleep 2.123;
	_bpos = getPosATL _fortress;
	_bpos set [2, 1];
	_sm_vehicle setFormDir ((direction _fortress) + 90);
	_sm_vehicle setPos _bpos;
	sleep 2.123;
	["specops", 2, "basic", 2, _poss, 200,true] spawn d_fnc_CreateInf;
	sleep 2.123;
	_leadero = leader _ogroup;
	_leadero setRank "COLONEL";
	_ogroup allowFleeing 0;
	_ogroup setbehaviour "AWARE";
	_leadero disableAI "MOVE";
};
