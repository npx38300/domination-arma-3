//by Xeno
#define THIS_FILE "fn_satellitedo.sqf"
#include "x_setup.sqf"
if (isDedicated || {!alive player} || {player getVariable ["xr_pluncon", false]}) exitWith {};

private "_exitj";
_exitj = false;
if (d_with_ranked) then {
	if (score player < (d_ranked_a select 19)) then {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_76", score player, d_ranked_a select 19];
		_exitj = true;
	} else {
		["d_pas", [player, (d_ranked_a select 19) * -1]] call d_fnc_NetCallEventCTS;
	};
};
if (_exitj) exitWith {};

[(_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3],'', 500, 200, 360, 0, [], 0] spawn d_fnc_establishingShot;
