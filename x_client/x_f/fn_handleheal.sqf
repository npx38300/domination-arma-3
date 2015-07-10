//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_handleheal.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_healed", "_healer"];
_healed = [_this, 0] call BIS_fnc_param;
_healer = [_this, 1] call BIS_fnc_param;
if (alive _healed && {alive _healer} && {_healed != _healer} && {!(_healed getVariable ["xr_pluncon", false])} && {!(_healer getVariable ["xr_pluncon", false])}) then {
	[_healed, _healer] spawn {
		scriptName "spawn_handleheal";
		private ["_healed", "_healer"];
		_healed = [_this, 0] call BIS_fnc_param;
		_healer = [_this, 1] call BIS_fnc_param;
		sleep 3;
		if (alive _healed && {alive _healer} && {_healed != _healer} && {!(_healed getVariable ["xr_pluncon", false])} && {!(_healer getVariable ["xr_pluncon", false])}) then {
			["d_pas", [_healer, d_ranked_a select 17]] call d_fnc_NetCallEventCTS;
			["d_pho", [_healer]] call d_fnc_NetCallEventSTO;
		};
	};
};
false