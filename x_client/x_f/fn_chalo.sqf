// by Xeno
#define THIS_FILE "fn_chalo.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private "_bpbp";
_bpbp = backpack player;
if (_bpbp != "" && {_bpbp != "B_Parachute"}) exitWith {
	(vehicle player) vehicleChat (localize "STR_DOM_MISSIONSTRING_1455");
};
player addBackpack "B_Parachute";

player action ["EJECT", _this select 0];
