// by Xeno
#define THIS_FILE "fn_airtaxi.sqf"
#include "x_setup.sqf"
private "_exitj";
if (isDedicated) exitWith {};
if !(local player) exitWith {};

if (!d_heli_taxi_available) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_139")};

if (d_FLAG_BASE distance player < 500) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_140")};

_exitj = false;
if (d_with_ranked) then {
	if (score player < (d_ranked_a select 15)) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_1424", score player, d_ranked_a select 15];
		_exitj = true;
	};
	["d_pas", [player, (d_ranked_a select 15) * -1]] call d_fnc_NetCallEventCTS;
};

if (_exitj) exitWith {};

d_heli_taxi_available = false;
publicVariable "d_heli_taxi_available";

player sideChat (localize "STR_DOM_MISSIONSTRING_141");

sleep 5;

[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_142");

["d_air_taxi", player] call d_fnc_NetCallEventCTS;