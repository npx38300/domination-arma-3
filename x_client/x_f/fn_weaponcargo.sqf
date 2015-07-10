// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_weaponcargo.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private "_vec";

_vec = [_this, 0] call BIS_fnc_param;
clearMagazineCargo _vec;
clearWeaponCargo _vec;
clearItemCargo _vec;
clearBackpackCargo _vec;

_vec setVariable ["d_player_ammobox", true];

__TRACE_1("","_vec")

if (!d_with_ranked) then {
	_vec spawn {
		waitUntil {time > 0};

		if (count (_this call BIS_fnc_getVirtualWeaponCargo) == 0 && {count (_this call BIS_fnc_getVirtualMagazineCargo) == 0}) then {
			__TRACE("Adding...")
			_helperar = [];
			_curar = d_misc_store getVariable "COLONEL_RIFLES";
			{
				 _helperar pushBack (_x select 0);
			} forEach _curar;
			__TRACE_2("","_this","_helperar")

			_curar = d_misc_store getVariable "COLONEL_LAUNCHERS";
			__TRACE_1("","_curar")
			{
				_helperar pushBack (_x select 0);
			} forEach _curar;
			_curar = d_misc_store getVariable "COLONEL_PISTOLS";
			{
				 _helperar pushBack (_x select 0);
			} forEach _curar;
			[_this, _helperar, false, false] call BIS_fnc_addVirtualWeaponCargo;

			_helperar = [];
			_curar = d_all_magazines;
			_helperar resize (count _curar);
			{
				 _helperar set [_forEachIndex, _x select 0];
			} forEach _curar;
			[_this, _helperar, false, false] call BIS_fnc_addVirtualMagazineCargo;

			_helperar = [];
			_curar = d_misc_store getVariable "COLONEL_OPTICS";
			{
				 _helperar pushBack (_x select 0);
			} forEach _curar;
			_curar = d_misc_store getVariable "COLONEL_MUZZLES";
			{
				 _helperar pushBack (_x select 0);
			} forEach _curar;
			_curar = d_misc_store getVariable "COLONEL_UNIFORMS";
			{
				 _helperar pushBack (_x select 0);
			} forEach _curar;
			_curar = d_misc_store getVariable "COLONEL_ITEMS";
			{
				 _helperar pushBack (_x select 0);
			} forEach _curar;
			[_this, _helperar, false, false] call BIS_fnc_addVirtualItemCargo;

			_helperar = [];
			_curar = d_backpackclasses;
			_helperar resize (count _curar);
			{
				 _helperar set [_forEachIndex, _x];
			} forEach _curar;
			[_this, _helperar, false, false] call BIS_fnc_addVirtualBackpackCargo;
		};
	};
} else {
	[_vec] spawn d_fnc_weaponcargo_ranked;
};
