//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_makemgroup.sqf"
#include "x_setup.sqf"

private ["_pos", "_unitliste", "_grp", "_ret"];
_pos = [_this, 0] call BIS_fnc_param;
_unitliste = [_this, 1] call BIS_fnc_param;
_grp = [_this, 2] call BIS_fnc_param;
_ret = [];
{
	_one_unit = _grp createUnit [_x, _pos, [], 10, "NONE"];
	if (d_with_ai && {d_with_ranked}) then {
		_one_unit addEventHandler ["MPKilled", {if (isServer) then {[1, _this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllEventHandlers "MPKilled"}}];
	};
	_one_unit setUnitAbility ((d_skill_array select 0) + (random (d_skill_array select 1)));
	_ret pushBack _one_unit;
	_one_unit call d_fnc_removeNVGoggles;
	_one_unit call d_fnc_removefak;
	#ifdef __GROUPDEBUG__
	// does not subtract if a unit dies!
	if (side _grp == d_side_enemy) then {
		d_infunitswithoutleader = d_infunitswithoutleader + 1;
	};
	#endif
} foreach _unitliste;
#ifdef __GROUPDEBUG__
if (side _grp == d_side_enemy) then {
	d_infunitswithoutleader = d_infunitswithoutleader - 1;
};
#endif
(leader _grp) setRank "SERGEANT";
[_grp, 1] call d_fnc_setGState;
_ret