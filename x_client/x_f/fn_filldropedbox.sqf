//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_filldropedbox.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

_box = [_this, 0] call BIS_fnc_param;
_boxcargo = [_this, 1] call BIS_fnc_param;

_box setVariable ["d_player_ammobox", true];

clearMagazineCargo _box;
clearWeaponCargo _box;
clearItemCargo _box;
clearBackpackCargo _box;

[_box, _boxcargo select 0, false, false] call BIS_fnc_addVirtualWeaponCargo;
[_box, _boxcargo select 1, false, false] call BIS_fnc_addVirtualMagazineCargo;
[_box, _boxcargo select 2, false, false] call BIS_fnc_addVirtualItemCargo;
[_box, _boxcargo select 3, false, false] call BIS_fnc_addVirtualBackpackCargo;
_box addAction ["<t color='#FF0000'>Virtual Ammobox System (VAS)</t>", "VAS\open.sqf", [], 6, true, true, "", "vehicle _this == _this && _this distance getPos _target < 6"];