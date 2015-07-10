// by Xeno
#define THIS_FILE "fn_moveai.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

if (((units (group player)) call d_fnc_GetAliveUnits) > 0) then {
	if (isNil "_this" || {_this isEqualTo []}) then {
		_pos_p = getPosATL player;
		_pos_p set [2,0];
		{if (!isPlayer _x && {vehicle _x == _x} && {_x distance _pos_p > 500}) then {_x setPos _pos_p}} forEach (formationMembers player);
	} else {
		_pos_p = [_this, 0] call BIS_fnc_param;
		_veloc = [_this, 1] call BIS_fnc_param;
		_dir = [_this, 2] call BIS_fnc_param;
		waitUntil {(vehicle player isKindOf "ParachuteBase") || {!alive player} || {player getVariable ["xr_pluncon", false]}};
		if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {};
		{
			if (!isPlayer _x && {vehicle _x == _x} && {_x distance _pos_p > 500}) then {
				_obj_para = createVehicle [d_non_steer_para, [0,0,100], [], 0, "FLY"];
				_obj_para setDir _dir;
				_obj_para setVelocity _veloc;
				_plpss = getPosASL player;
				_obj_para setPos [(_plpss select 0) + random 10, (_plpss select 1) + random 10, ((getPosATL player) select 2) + random 10];
				_x moveInDriver _obj_para;
				[_x] spawn {
					scriptName "spawnx_moveai_paraAI";
					_unit = [_this, 0] call BIS_fnc_param;
					sleep 0.8321;
					waitUntil {sleep 0.111;(vehicle _unit == _unit || {!alive _unit})};
					if (alive _unit) then {if ((getPosATL _unit) select 2 > 1) then {[_unit, 0] call d_fnc_SetHeight}};
				};
			};
		} forEach (formationMembers player);
	};
};