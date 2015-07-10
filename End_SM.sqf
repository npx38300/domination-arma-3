// Created by: Tankbuster
// Modified by: Dirty Haz

#define THIS_FILE "End_SM.sqf"
#include "x_setup.sqf"

d_sm_winner = -999;
d_sm_resolved = true;
publicVariable "d_sm_winner";
publicVariable "d_sm_resolved";
if d_IS_HC_CLIENT then {
[d_sm_var, d_sm_winner] call d_NetCallEventCTS;
};
[{systemChat "The Side Mission has been ended by the server admin.";}, "BIS_fnc_spawn", nil, false] call BIS_fnc_MP;