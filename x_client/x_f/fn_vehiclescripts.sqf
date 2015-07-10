//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_vehiclescripts.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

d_player_in_vec = true;
private ["_vec", "_isAir"];
_vec = vehicle player;
if ((_vec isKindOf "ParachuteBase") || {_vec isKindOf "BIS_Steerable_Parachute"}) exitWith {};
_isAir = _vec isKindOf "Air";
__TRACE_2("d_fnc_vehicleScripts","_vec","_isAir")
if (_isAir) then {
	if (_vec isKindOf "Helicopter") then {
		0 spawn d_fnc_chop_hudsp;
	};
	if (d_pilots_only == 0 && {!(call d_fnc_isPilotCheck)} && {player == driver _vec}) then {
		player action ["getOut", _vec];
		hintSilent localize "STR_DOM_MISSIONSTRING_1417";
	};
} else {
	if ((_vec isKindOf "LandVehicle" && {!(_vec isKindOf "StaticWeapon")}) || {_vec isKindOf "StaticWeapon" && {!(_vec isKindOf "StaticATWeapon")}}) then {
		0 spawn d_fnc_vec_hudsp;
	};
	if (d_MHQDisableNearMT != 0 && {!d_playerInMHQ}) then {
		if ((_vec getVariable ["d_vec_type", ""]) == "MHQ") then {
			d_playerInMHQ = true;
			0 spawn d_fnc_mhqCheckNearTarget;
		};
	};
};
if (d_with_ranked) then {
	if (_vec isKindOf "Car" || {_vec isKindOf "Helicopter"}) then {
		0 spawn d_fnc_playervectrans;
	};
	call d_fnc_playerveccheck;
};
if (d_without_vec_ti == 0) then {
	_vec disableTIEquipment true;
};

if (toUpper (typeOf _vec) in d_check_ammo_load_vecs) then {
	[d_AMMOLOAD] execFSM "fsms\AmmoLoad.fsm";
};