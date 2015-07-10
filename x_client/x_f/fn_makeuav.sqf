// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makeuav.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_uav"];

if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {};

_exitj = false;
if (d_with_ranked) then {
	if (score player < (d_ranked_a select 19)) then {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_76b", score player,d_ranked_a select 19];
		_exitj = true;
	} else {
		["d_pas", [player, (d_ranked_a select 19) * -1]] call d_fnc_NetCallEventCTS;
	};
};
if (_exitj) exitWith {};

if !(d_UAV_Terminal in (assignedItems player)) then {
	player setVariable ["d_has_gps", "ItemGPS" in (assignedItems player)];
	player linkItem d_UAV_Terminal;
};

_uav = [getPosATL player, 0, d_UAV_Small, side (group player)] call bis_fnc_spawnVehicle;
__TRACE_1("","_uav")
createVehicleCrew (_uav select 0);

player connectTerminalToUav (_uav select 0);

player action ["UAVTerminalOpen"];

["d_p_o_a2", [d_string_player, _uav]] call d_fnc_NetCallEventCTS;

_uav spawn {
	private "_uav";
	_uav = [_this, 0] call BIS_fnc_param;
	while {!isNull (getConnectedUav player) && {alive player} && {!(player getVariable ["xr_pluncon", false])} && {alive _uav}} do {
		sleep 1.1;
	};
	if (alive player && {!(player getVariable ["xr_pluncon", false])} && {player getVariable ["d_has_gps", false]}) then {
		player linkItem "ItemGPS";
		player setVariable ["d_has_gps", false];
	};
	
	if (!isNull _uav) then {
		["d_p_o_a2r", [d_string_player, _uav]] call d_fnc_NetCallEventCTS;
	};
	deleteVehicle _uav;
	(findDisplay 160) closeDisplay 1;
};
