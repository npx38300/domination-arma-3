//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_domend.sqf"
#include "x_setup.sqf"

sleep 5;
["d_the_end", 0] call d_fnc_NetCallEventToClients;
sleep 38;
["d_the_end", 1] call d_fnc_NetCallEventToClients;
endMission "END1";
forceEnd;