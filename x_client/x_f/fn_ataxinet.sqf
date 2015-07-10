//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_ataxinet.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};
private "_strout";
_strout = "";
switch (_this select 1) do {
	case 0: {_strout = localize "STR_DOM_MISSIONSTRING_634"};
	case 1: {_strout = localize "STR_DOM_MISSIONSTRING_635";d_heli_taxi_available = true};
	case 2: {_strout = localize "STR_DOM_MISSIONSTRING_636";d_heli_taxi_available = true};
	case 3: {_strout = localize "STR_DOM_MISSIONSTRING_637"};
	case 4: {_strout = localize "STR_DOM_MISSIONSTRING_638";d_heli_taxi_available = true};
	case 5: {_strout = localize "STR_DOM_MISSIONSTRING_639"};
	case 6: {_strout = localize "STR_DOM_MISSIONSTRING_640"};
};
if (_strout != "") then {
	[playerSide, "HQ"] sideChat _strout;
};
if (d_heli_taxi_available) then {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_1453");
};