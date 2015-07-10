// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_ptakeweapon.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

__TRACE_1("","_this")

private ["_unit","_container","_item", "_exit_it","_cfgi"];
_unit = [_this, 0] call BIS_fnc_param;
if (_unit != player) exitWith {};
_container = [_this, 1] call BIS_fnc_param;
_item = [_this, 2] call BIS_fnc_param;

_cfgi = configFile/"CfgWeapons"/_item;

if (!isClass(_cfgi)) exitWith {
	__TRACE_1("not of type weapon","_item")
};

_item = toUpper _item;

_rank = rank player;
__TRACE_1("","_rank")
_isvalid = _item in (d_misc_store getVariable (_rank + "_ONED"));

_exit_it = false;
if (!_isvalid) then {
	if !(_item in d_non_check_items) then {
		_prw = player getVariable "d_pprimweap";
		if (_prw != primaryWeapon player) then {
			player addWeapon _prw;
			
			_secits = player getVariable "d_pprimweapitems";
			if !(primaryWeaponItems player isEqualTo _secits) then {
				removeAllPrimaryWeaponItems player;
				{if (_x != "") then {player addPrimaryWeaponItem _x}} forEach _secits;
			};
			
			_exit_it = true;
		} else {
			_prw = player getVariable "d_psecweap";
			if (_prw != secondaryWeapon player) then {
				player addWeapon _prw;
				
				_secits = player getVariable "d_psecweapitems";
				if !(secondaryWeaponItems player isEqualTo _secits) then {
					// removeAllSecondaryWeaponItems player; // this command does not exist in A3 even after 1 1/2 year...
					{if (_x != "") then {player addSecondaryWeaponItem _x}} forEach _secits;
				};
				
				_exit_it = true;
			} else {
				_prw = player getVariable "d_phandgweap";
				if (_prw != handgunWeapon player) then {
					player addWeapon _prw;
					
					_secits = player getVariable "d_phandgweapitems";
					if !(handgunItems player isEqualTo _secits) then {
						removeAllHandgunItems player;
						{if (_x != "") then {player addHandgunItem _x}} forEach _secits;
					};
					
					_exit_it = true;
				};
			};
		};
	};
};

if (_exit_it) exitWith {
	_type = getNumber(_cfgi/"type");
	__TRACE_1("","_type")
	_container addItemCargo [_item, 1];
	systemChat format [localize "STR_DOM_MISSIONSTRING_1564", _rank, getText(_cfgi/"displayname")];
};

call d_fnc_store_rwitems;
