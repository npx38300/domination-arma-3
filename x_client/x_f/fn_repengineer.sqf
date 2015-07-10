// by Xeno
#define THIS_FILE "fn_repengineer.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_aid","_caller","_coef","_damage","_damage_ok","_damage_val","_fuel","_fuel_ok","_fuel_val","_rep_count","_breaked_out","_rep_action","_type_name", "_exitit"];

_caller = _this select 1;
_aid = _this select 2;

_truck_near = (player distance TR7 < 21 || {player distance TR8 < 21});
if (!d_eng_can_repfuel && {!_truck_near}) exitWith {
	hintSilent (localize "STR_DOM_MISSIONSTRING_324");
};

_exitit = false;
if (d_with_ranked) then {
	if (score player < (d_ranked_a select 0)) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_325", score player, (d_ranked_a select 0)];
		_exitit = true;
	};
	if (time >= d_last_base_repair) then {d_last_base_repair = -1};
};
if (_exitit) exitWith {};

if (d_with_ranked && {player in (list d_engineer_trigger)} && {d_last_base_repair != -1}) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_326");
};

if (d_with_ranked && {player in (list d_engineer_trigger)}) then {d_last_base_repair = time + 300};

_caller removeAction _aid;
if !(local _caller) exitWith {};

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
_coef = ceil (_damage_val max _fuel_val);

hintSilent format [localize "STR_DOM_MISSIONSTRING_327", _fuel, _damage];
_type_name = [typeOf d_objectID2, "CfgVehicles"] call d_fnc_GetDisplayName;
systemChat format [localize "STR_DOM_MISSIONSTRING_328", _type_name];
_damage_ok = false;
_fuel_ok = false;
d_cancelrep = false;
_breaked_out = false;
_rep_action = player addAction[(localize "STR_DOM_MISSIONSTRING_329") call d_fnc_RedText,{d_cancelrep = true}];
for "_wc" from 1 to _coef do {
	if (!alive player || {d_cancelrep}) exitWith {player removeAction _rep_action};
	systemChat (localize "STR_DOM_MISSIONSTRING_330");
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 1;
	waitUntil {animationState player != "AinvPknlMstpSlayWrflDnon_medic" || {!alive player} || {player getVariable ["xr_pluncon", false]}};
	if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {
		_breaked_out = true;
		player removeAction _rep_action;
	};
	if (d_cancelrep) exitWith {
		_breaked_out = true;
		systemChat (localize "STR_DOM_MISSIONSTRING_332");
		player removeAction _rep_action;
	};
	if (vehicle player != player) exitWith {
		_breaked_out = true;
		hintSilent (localize "STR_DOM_MISSIONSTRING_331");
	};
	if (!_fuel_ok) then {_fuel = _fuel + _rep_count};
	if (_fuel >= 1 && {!_fuel_ok}) then {_fuel = 1;_fuel_ok = true};
	if (!_damage_ok) then {_damage = _damage - _rep_count};
	if (_damage <= 0.01 && {!_damage_ok}) then {_damage = 0;_damage_ok = true};
	hintSilent format [localize "STR_DOM_MISSIONSTRING_327", _fuel, _damage];
};
if (_breaked_out) exitWith {};
d_eng_can_repfuel = false;
player removeAction _rep_action;
if (!alive player) exitWith {player removeAction _rep_action};
if (d_with_ranked) then {
	_parray = d_ranked_a select 1;
	_addscore = if (d_objectID2 isKindOf "Air") then {
		_parray select 0
	} else {
		if (d_objectID2 isKindOf "Tank") then {
			_parray select 1
		} else {
			if (d_objectID2 isKindOf "Car") then {
				_parray select 2
			} else {
				_parray select 3
			};
		};
	};
	if (_addscore > 0) then {
		["d_pas", [player, _addscore]] call d_fnc_NetCallEventCTS;
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_333", _addscore];
	};
};
["d_rep_ar", d_objectID2] call d_fnc_NetCallEvent;
systemChat format [localize "STR_DOM_MISSIONSTRING_334", _type_name];
