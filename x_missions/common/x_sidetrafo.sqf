// by Xeno
#define THIS_FILE "x_sidetrafo.sqf"
#include "x_setup.sqf"
if !(call d_fnc_checkSHC) exitWith {};

_poss = [_this, 0] call BIS_fnc_param;

_objs = nearestObjects [_poss, ["Land_trafostanica_velka"], 40];

sleep 2.123;
["specops", 2, "basic", 1, _poss,200,true] spawn d_fnc_CreateInf;
sleep 2.221;
["aa", 1, "tracked_apc", 1, "tank", 1, _poss,1,300,true] spawn d_fnc_CreateArmor;

while {(_objs call d_fnc_GetAliveUnits) > 0} do {sleep 5.326};

_objs = nil;

d_sm_winner = 2;
d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};