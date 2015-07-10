//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getadminarray.sqf"
#include "x_setup.sqf"

["d_s_p_inf", [_this select 0, d_player_store getVariable [_this select 1, []]]] call d_fnc_NetCallEventSTO;