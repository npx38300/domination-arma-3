// by Xeno
#define THIS_FILE "fn_healatmash.sqf"
#include "x_setup.sqf"
private ["_target","_caller"];
_target = [_this, 0] call BIS_fnc_param;
_caller = [_this, 1] call BIS_fnc_param;

if (isDedicated || {_caller != player} || {!alive player} || {player getVariable ["xr_pluncon", false]}) exitWith {};

player setVariable ["d_isinaction", true];

player playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 1;
waitUntil {animationState player != "AinvPknlMstpSlayWrflDnon_medic" || {!alive player} || {player getVariable ["xr_pluncon", false]}};
player setVariable ["d_isinaction", false];
if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {};

player setDamage 0;

if (d_with_ranked) then {
	["d_ampoi", [_target, name player]] call d_fnc_NetCallEventCTS;
};
