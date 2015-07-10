// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_load_static.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vec","_cargo","_tr_cargo_ar","_alive","_cargo_type","_type_name"];

_vec = [_this, 0] call BIS_fnc_param;
_cargo = objNull;

if (!d_with_ai && {d_with_ai_features != 0} && {!(d_string_player in d_is_engineer)}) exitWith {
	hintSilent (localize "STR_DOM_MISSIONSTRING_68");
};

_tr_cargo_ar = _vec getVariable ["d_CARGO_AR", []];

if (count _tr_cargo_ar >= d_max_truck_cargo) exitWith {
	systemChat format [localize "STR_DOM_MISSIONSTRING_69", d_max_truck_cargo];
};

_cargo = nearestObject [_vec, "StaticWeapon"];
if (isNull _cargo) exitWith {hintSilent (localize "STR_DOM_MISSIONSTRING_70")};
if (!alive _cargo) exitWith {hintSilent (localize "STR_DOM_MISSIONSTRING_71")};
_cargo_type = typeOf _cargo;
_type_name = [_cargo_type, "CfgVehicles"] call d_fnc_GetDisplayName;
if (_cargo distance _vec > 10) exitwith {hintSilent format [localize "STR_DOM_MISSIONSTRING_72", _type_name]};
if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {};

if (player getVariable ["d_currently_loading", false]) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_73")};

player setVariable ["d_currently_loading", true];
_tr_cargo_ar = _vec getVariable ["d_CARGO_AR", []];
if (count _tr_cargo_ar >= d_max_truck_cargo) then {
	systemChat format [localize "STR_DOM_MISSIONSTRING_69", d_max_truck_cargo];
} else {
	_tr_cargo_ar pushBack _cargo_type;
	_vec setVariable ["d_CARGO_AR", _tr_cargo_ar, true];
};
_alive = true;
for "_i" from 10 to 1 step -1 do {
	hintSilent format [localize "STR_DOM_MISSIONSTRING_74", _type_name, _i];
	if (!alive player || {!alive _vec} || {player getVariable ["xr_pluncon", false]}) exitWith {_alive = false};
	sleep 1;
};
if (_alive) then {
	deleteVehicle _cargo;
	hintSilent format [localize "STR_DOM_MISSIONSTRING_75", _type_name];
};
player setVariable ["d_currently_loading", false];
