// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_save_layoutgear.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_p", "_prim_pweap_mag", "_prim_pweap_mag_class", "_sec_pweap_mag", "_sec_pweap_mag_class", "_handgun_pweap_mag", "_handgun_pweap_mag_class"];

_p = player;
if (primaryWeapon _p == "") exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_341")};

_backpack = backpack _p;

_backpackcargo = if (_backpack != "") then {
	backpackCargo (unitBackpack _p);
} else {
	[]
};

d_custom_layout = [
	((assignedItems _p) - [headgear _p] - [goggles _p]),  //0
	magazinesAmmoFull _p, //1
	primaryWeapon _p, //2
	primaryWeaponItems _p, //3
	secondaryWeapon _p, //4
	secondaryWeaponItems _p, //5
	handgunWeapon _p, //6
	handgunItems _p, //7
	"", //8
	uniform _p, //9
	vest _p, // 10
	_backpack, //11
	goggles _p, //12
	headgear _p, //13
	items _p, //14
	_backpackcargo, // 15
	magazines _p, // 16
	binocular _p // 17
];

player setVariable ["d_custom_backpack", if !((player getVariable "d_player_backpack") isEqualTo []) then {
	player getVariable "d_player_backpack"
} else {
	[]
}];

__TRACE_1("","d_custom_layout")
