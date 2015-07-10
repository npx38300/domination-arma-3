// by Xeno
#define THIS_FILE "fn_repanalyze.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_coef","_damage","_damage_val","_fuel","_fuel_val","_rep_count"];

if !(local (_this select 1)) exitWith {};

_rep_count = if (d_objectID2 isKindOf "Air") then {
	0.1
} else {
	if (d_objectID2 isKindOf "Tank") then {
		0.2
	} else {
		0.3
	};
};

_fuel = fuel d_objectID2;
_damage = damage d_objectID2;

_damage_val = _damage / _rep_count;
_fuel_val = (1 - _fuel) / _rep_count;
_coef = _damage_val max _fuel_val;

hintSilent format [localize "STR_DOM_MISSIONSTRING_323", _fuel, _damage, (ceil _coef) * 3, [typeOf (d_objectID2), "CfgVehicles"] call d_fnc_GetDisplayName];