//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_checkshc.sqf"
#include "x_setup.sqf"

if (d_IS_HC_CLIENT) exitWith {true};
if (isServer) exitWith {true};
false