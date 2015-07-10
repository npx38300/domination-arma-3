// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_save_respawngear.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_handgunmuzzles"];
_p = player;
// oh boy... who designed this item system where you are not able to simply read primary and secondary magazines
// furthermore you are not able to retrieve those from dead units
_assigneditems = (assignedItems _p) - [headgear _p] - [goggles _p];
__TRACE_1("","_assigneditems")
_p setVariable ["d_respawn_assignedItems", _assigneditems];

_magsammofull = magazinesAmmoFull _p;
__TRACE_1("","_magsammofull")
_p setVariable ["d_respawn_magazinesAmmoFull", _magsammofull];
#ifdef __DEBUG__
{
	__TRACE_1("","_x")
} forEach _magsammofull;
#endif

_handgun_pweap = handgunWeapon _p;
__TRACE_1("","_handgun_pweap")
_p setVariable ["d_respawn_handgunWeapon", _handgun_pweap];
_sec_pweap = secondaryWeapon _p;
__TRACE_1("","_sec_pweap")
_p setVariable ["d_respawn_secondaryWeapon", _sec_pweap];
_prim_pweap = primaryWeapon _p;
__TRACE_1("","_prim_pweap")
_p setVariable ["d_respawn_primaryWeapon", _prim_pweap];

_prim_weapItems = primaryWeaponItems _p;
__TRACE_1("","_prim_weapItems")
_p setVariable ["d_respawn_primweapitems", _prim_weapItems];
_sec_weapItems = secondaryWeaponItems _p;
__TRACE_1("","_sec_weapItems")
_p setVariable ["d_respawn_secweapitems", _sec_weapItems];
_handgun_Items = handgunItems _p;
__TRACE_1("","_handgun_Items")
_p setVariable ["d_respawn_handgunItems", _handgun_Items];
_uniform = uniform _p;
__TRACE_1("","_uniform")
_p setVariable ["d_respawn_uniform", _uniform];

_vest = vest _p;
__TRACE_1("","_vest")
_p setVariable ["d_respawn_vest", _vest];

_backpack = backpack _p;
__TRACE_1("","_backpack")
_p setVariable ["d_respawn_backpack", _backpack];

if (_backpack != "") then {
	_backpackcargo = backpackCargo (unitBackpack _p);
	__TRACE_1("","_backpackcargo")
	_p setVariable ["d_respawn_backpack_backpack", _backpackcargo];
} else {
	_p setVariable ["d_respawn_backpack_backpack", []];
};

_goggles = goggles _p;
__TRACE_1("","_goggles")
_p setVariable ["d_respawn_goggles", _goggles];
_headgear = headgear _p;
__TRACE_1("","_headgear")
_p setVariable ["d_respawn_headgear", _headgear];

_items = items _p;
__TRACE_1("","_items")
_p setVariable ["d_respawn_items", _items];

_bino = binocular _p;
__TRACE_1("","_bino")
_p setVariable ["d_binocular", _bino];