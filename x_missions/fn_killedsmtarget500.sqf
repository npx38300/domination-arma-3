//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_killedsmtarget500.sqf"
#include "x_setup.sqf"

d_sm_winner = -500;
d_sm_resolved = true;
(_this select 0) removeAllEventHandlers "killed";
if (d_IS_HC_CLIENT) then {
	["d_sm_var", d_sm_winner] call d_fnc_NetCallEventCTS;
};