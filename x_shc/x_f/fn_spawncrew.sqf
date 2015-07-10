// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_spawncrew.sqf"
#include "x_setup.sqf"

private ["_vec", "_grp", "_crew"];
_vec = [_this, 0] call BIS_fnc_param;
_grp = [_this, 1] call BIS_fnc_param;

createVehicleCrew _vec;
_crew = crew _vec;
if (count _crew > 0) then {
	_grp_old = group (_crew select 0);
	_crew joinSilent _grp;
	deleteGroup _grp_old;
	{
		_x call d_fnc_removeNVGoggles;
		_x call d_fnc_removefak;
		if (d_with_ai && {d_with_ranked}) then {
			_x addEventHandler ["MPKilled", {if (isServer) then {[1, _this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllEventHandlers "MPKilled"}}];
		};
		_x setUnitAbility ((d_skill_array select 0) + (random (d_skill_array select 1)));
	} forEach _crew;
	if !(isNull (driver _vec)) then {(driver _vec) setRank "LIEUTENANT"};
	if !(isNull (gunner _vec)) then {(gunner _vec) setRank "SERGEANT"};
	if !(isNull (effectiveCommander _vec)) then {(effectiveCommander _vec) setRank "CORPORAL"};
};

__TRACE_1("","_crew")

[_grp, 1] call d_fnc_setGState;

_crew
