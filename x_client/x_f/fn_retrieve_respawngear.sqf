// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_retrieve_respawngear.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_p","_bpadded"];
_p = player;

removeAllWeapons _p;
removeAllItems _p;
removeAllAssignedItems _p;
while {!(magazines _p isEqualTo [])} do {
	_p removeMagazines ((magazines _p) select 0);
};
{_p linkItem _x} forEach (player getVariable "d_respawn_assignedItems");
_bino = player getVariable "d_binocular";
if (_bino != "") then {
	_p addWeapon _bino;
};

_runi = player getVariable "d_respawn_uniform";
__TRACE_1("","_runi")
removeUniform _p;
_p addUniform _runi;

_rvest = player getVariable "d_respawn_vest";
__TRACE_1("","_rvest")
removeVest _p;
_p addVest _rvest;

_backp = player getVariable "d_respawn_backpack";
__TRACE_1("","_backp")
removeBackpackGlobal _p;
if (_backp != "") then {
	_p addBackpackGlobal _backp;
	clearBackpackCargoGlobal _p;
	clearAllItemsFromBackpack _p;
};

_backbackp = player getVariable "d_respawn_backpack_backpack";
__TRACE_1("","_backbackp")
if !(_backbackp isEqualTo []) then {
	_unitbp = unitBackpack _p;
	if (!isNull _unitbp) then {
		{
			__TRACE_1("adding backpack","_x")
			_unitbp addBackpackCargoGlobal [_x, 1];
		} forEach _backbackp;
	};
};

_bpadded = false;
if (isNull unitBackpack _p) then {
	__TRACE("add dummy backpack")
	_p addBackpackGlobal "B_HuntingBackpack";
	_bpadded = true;
};

_magsammofull =+ (player getVariable "d_respawn_magazinesAmmoFull");

_xupd = false;
{
	if (_x select 2 && {!((_x select 0) isKindOf "Grenade")}) then {
		__TRACE_1("loaded mag","_x")
		_p addMagazine [_x select 0, _x select 1];
		_magsammofull set [_forEachIndex, -1];
		_xupd = true;
	};
} forEach _magsammofull;
if (_xupd) then {
	_magsammofull = _magsammofull - [-1];
};

_rsecw = player getVariable "d_respawn_secondaryWeapon";
__TRACE_1("","_rsecw")
if (_rsecw != "") then {
	_p addWeapon _rsecw;
	{
		if (_x != "") then {
			__TRACE_1("secWeapItem","_x")
			_p addSecondaryWeaponItem _x;
		}
	} forEach (player getVariable "d_respawn_secweapitems");
};

_rhandgw = player getVariable "d_respawn_handgunWeapon";
if (_rhandgw != "") then {
	_p addWeapon _rhandgw;
	removeAllHandgunItems _p;
	{
		if (_x != "") then {
			__TRACE_1("handGunItem","_x")
			_p addHandgunItem _x;
		}
	} forEach (player getVariable "d_respawn_handgunItems");
};

_rprimw = player getVariable "d_respawn_primaryWeapon";
if (_rprimw != "") then {
	_p addWeapon _rprimw;
	removeAllPrimaryWeaponItems _p;
	{
		if (_x != "") then {
			__TRACE_1("primWeapItem","_x")
			_p addPrimaryWeaponItem _x;
		}
	} forEach (player getVariable "d_respawn_primweapitems");
};

if (_bpadded) then {
	removeBackpackGlobal _p;
};

_gogs = player getVariable "d_respawn_goggles";
__TRACE_1("","_gogs")
if (goggles _p != _gogs) then {
	removeGoggles _p;
	_p addGoggles _gogs;
};

_headg = player getVariable "d_respawn_headgear";
__TRACE_1("","_headg")
if (headgear _p != _headg) then {
	removeHeadgear _p;
	_p addHeadgear _headg;
};

_grenademags = [];
{
	_ammo = getText(configFile/"CfgMagazines"/(_x select 0)/"ammo");
	if (getText(configFile/"CfgAmmo"/_ammo/"simulation") != "shotGrenade") then {
		_p addMagazine [_x select 0, _x select 1];
	} else {
		_grenademags pushBack [_x select 0, _x select 1, _x select 4];
	};
	__TRACE_1("","_x")
} forEach _magsammofull;

_grenademags spawn {
	sleep 5;
	__TRACE_1("spawn _grenademags","_this")
	{
		player addMagazine _x;
	} forEach _this;
};

{
	__TRACE_1(" item","_x")
	_p addItem _x;
} forEach (player getVariable "d_respawn_items");

if (binocular _p == "LaserDesignator") then {
	_p addMagazine ["Laserbatteries", 1];
};

_primw = primaryWeapon _p;
if (_primw != "") then {
	_p selectWeapon _primw;
	_muzzles = getArray(configFile/"cfgWeapons"/_primw/"muzzles");
	_p selectWeapon (_muzzles select 0);
};
