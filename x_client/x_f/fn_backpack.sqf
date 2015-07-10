// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_backpack.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_anim","_mag_types","_magazines","_mags_backpack","_muzzles","_p","_primary","_s","_pistol","_base", "_convertFunc", "_magsdetail", "_curPistMag", "_curPistMagClass", "_loaded_mags"];
_p = player;

_convertFunc = {
	_mags_with_ammo = [];
	{
		_mags_with_ammo pushBack [_x, ((_this select 1) select _forEachIndex) call d_fnc_extractMagVals];
	} forEach (_this select 0);
	__TRACE_1("_convertFunc","_mags_with_ammo")
	_mags_with_ammo
};

_getMuzzleMags = {
	private ["_weapon", "_mags", "_muzzles"];
	_weapon = [_this, 0] call BIS_fnc_param;
	if (_weapon == "") exitWith {[]};
	_muzzles = getArray(configFile/"cfgWeapons"/_weapon/"muzzles");
	__TRACE_1("_getMuzzleMags","_muzzles")
	_mags = [];
	{
		__TRACE_1("_getMuzzleMags","_x")
		_newmags = if (_x != "this") then {
			getArray(configFile/"cfgWeapons"/_weapon/_x/"magazines");
		} else {
			getArray(configFile/"cfgWeapons"/_weapon/"magazines");
		};
		__TRACE_1("_getMuzzleMags","_newmags")
		if !(_newmags isEqualTo []) then {
			[_mags, _newmags] call d_fnc_arrayPushStack;
		};
	} forEach _muzzles;
	__TRACE_1("_getMuzzleMags","_mags")
	_mags
};

if ((player getVariable "d_player_backpack") isEqualTo []) then {
	_primary = primaryWeapon _p;
	__TRACE_1("","_primary")
	if (_primary != "") then {
		_mag_types = [_primary] call _getMuzzleMags;
		{
			_mag_types set [_forEachIndex, toUpper _x];
		} forEach _mag_types;
		_cur_weap_p = currentWeapon _p;
		_cur_muz = currentMuzzle _p;
		_loaded_mags = [_primary] call d_fnc_getLoadedMags;
		_magazines = magazines _p;
		_magsdetail = magazinesDetail _p;
		_p selectWeapon _cur_weap_p;
		_p selectWeapon _cur_muz;
		__TRACE_1("bp empty","_magazines")
		__TRACE_1("bp empty","_magsdetail")
		
		_mags_backpack = [];
		_mags_backpack_detail = [];
		{
			_tou = toUpper _x;
			if (_tou in _mag_types) then {
				_mags_backpack pushBack _tou;
				_mags_backpack_detail pushBack (_magsdetail select _forEachIndex);
			};
		} forEach _magazines;
		__TRACE_1("bp empty","_mags_backpack_detail")
		_primary_items = primaryWeaponItems _p;
		_mags_with_ammocount = [_mags_backpack, _mags_backpack_detail] call _convertFunc;
		_loadedmags_with_ammocount = [_loaded_mags select 1, _loaded_mags select 0] call _convertFunc;
		__TRACE_1("bp empty","_mags_with_ammocount")
		__TRACE_1("bp empty","_loadedmags_with_ammocount")
		d_backpack_helper = [_primary, _mags_with_ammocount, _primary_items, _loadedmags_with_ammocount];
		__TRACE_1("bp empty","d_backpack_helper")
		_pistol = handgunWeapon _p;
		if (_pistol != "") then {
			_curmuzp = currentMuzzle _p;
			_curweapp = currentWeapon _p;
			_p selectWeapon _pistol;
			_curPistMag = currentMagazineDetail _p;
			_curPistMagClass = currentMagazine _p;
			_p selectWeapon _curweapp;
			_p selectWeapon _curmuzp;
			_p removeWeapon _pistol;
		};
		{_p removeMagazine _x} forEach _mags_backpack;
		_p removeWeapon _primary;
		_anim = animationState _p;
		player setVariable ["d_player_backpack", [_primary, _mags_with_ammocount, _primary_items, _loadedmags_with_ammocount]];
		waitUntil {animationState player != _anim || {!alive player}};
		if (!alive player) exitWith {};
		_p = player;
		if (_pistol != "") then {
			_p addMagazine [_curPistMagClass, _curPistMag call d_fnc_extractMagVals];
			_p addWeapon _pistol;
			_p selectWeapon _pistol;
		};
		if (alive player) then {d_backpack_helper = []};
	};
} else { // switch weapon
	_primary = primaryWeapon _p;
	__TRACE_1("2","_primary")
	if (_primary == "") then {
		_loaded_mags = (player getVariable "d_player_backpack") select 3;
		__TRACE_1("no prim","_loaded_mags")
		if !(_loaded_mags isEqualTo []) then {
			{
				_p addMagazine _x;
			} forEach _loaded_mags;
		};
		_p addWeapon ((player getVariable "d_player_backpack") select 0);
		_bpmagsx = (player getVariable "d_player_backpack") select 1;
		if !(_bpmagsx isEqualTo []) then {
			{_p addMagazine _x} forEach _bpmagsx;
		};
		_bpmagsx = nil;
		{if (_x != "") then {_p removePrimaryWeaponItem _x}} forEach (primaryWeaponItems _p);
		{if (_x != "") then {_p addPrimaryWeaponItem _x}} foreach ((player getVariable "d_player_backpack") select 2);
		_muzzles = getArray(configFile/"cfgWeapons"/((player getVariable "d_player_backpack") select 0)/"muzzles");
		_p selectWeapon ((player getVariable "d_player_backpack") select 0);
		_p selectWeapon (_muzzles select 0);
		player setVariable ["d_player_backpack", []];
	} else {
		_mag_types = [_primary] call _getMuzzleMags;
		{
			_mag_types set [_forEachIndex, toUpper _x];
		} forEach _mag_types;
		_cur_weap_p = currentWeapon _p;
		_cur_muz = currentMuzzle _p;
		_loaded_mags = [_primary] call d_fnc_getLoadedMags;
		_magazines = magazines _p;
		_magsdetail = magazinesDetail _p;
		_p selectWeapon _cur_weap_p;
		_p selectWeapon _cur_muz;
		__TRACE_1("prim there","_magazines")
		__TRACE_1("prim there","_magsdetail")
		__TRACE_1("prim there","_loaded_mags")
		_mags_backpack = [];
		_mags_backpack_detail = [];
		{
			_tou = toUpper _x;
			if (_tou in _mag_types) then {
				_mags_backpack pushBack _tou;
				_mags_backpack_detail pushBack (_magsdetail select _forEachIndex);
				__TRACE_1("prim there","_forEachIndex")
				#ifdef __DEBUG__
				_mdfei = _magsdetail select _forEachIndex;
				__TRACE_1("prim there","_mdfei")
				#endif
			};
		} forEach _magazines;
		_primary_items = primaryWeaponItems _p;
		__TRACE_1("prim there","_mags_backpack")
		__TRACE_1("prim there","_magsdetail")
		_mags_with_ammocount = [_mags_backpack, _mags_backpack_detail] call _convertFunc;
		_loadedmags_with_ammocount = [_loaded_mags select 1, _loaded_mags select 0] call _convertFunc;
		__TRACE_1("prim there","_mags_with_ammocount")
		__TRACE_1("prim there","_loadedmags_with_ammocount")
		d_backpack_helper = [_primary, _mags_with_ammocount, _primary_items, _loadedmags_with_ammocount];
		__TRACE_1("prim there","d_backpack_helper")
		_pistol = handgunWeapon _p;
		__TRACE_1("prim there","_pistol")
		if (_pistol != "") then {
			_curmuzp = currentMuzzle _p;
			_curweapp = currentWeapon _p;
			_p selectWeapon _pistol;
			_curPistMagClass = currentMagazine _p;
			_curPistMag = currentMagazineDetail _p;
			_p selectWeapon _curweapp;
			_p selectWeapon _curmuzp;
			_p removeWeapon _pistol;
		};
		{_p removeMagazine _x} forEach _mags_backpack;
		_p removeWeapon _primary;
		sleep 1;
		_anim = animationState _p;
		waitUntil {animationState player != _anim || {!alive player}};
		if (!alive player) exitWith {};
		_p = player;
		_oloaded_mags = (player getVariable "d_player_backpack") select 3;
		if !(_oloaded_mags isEqualTo []) then {
			{
				_p addMagazine _x;
			} forEach _oloaded_mags;
		};
		if (_pistol != "") then {
			_p addMagazine [_curPistMagClass, _curPistMag call d_fnc_extractMagVals];
			_p addWeapon _pistol;
		};
		_p addWeapon ((player getVariable "d_player_backpack") select 0);
		_bpmagsx = (player getVariable "d_player_backpack") select 1;
		if !(_bpmagsx isEqualTo []) then {
			{_p addMagazine _x} forEach _bpmagsx;
		};
		_bpmagsx = nil;
		{if (_x != "") then {_p removePrimaryWeaponItem _x}} forEach (primaryWeaponItems _p);
		{if (_x != "") then {_p addPrimaryWeaponItem _x}} foreach ((player getVariable "d_player_backpack") select 2);
		_muzzles = getArray(configFile/"cfgWeapons"/((player getVariable "d_player_backpack") select 0)/"muzzles");
		_p selectWeapon ((player getVariable "d_player_backpack") select 0);
		_p selectWeapon (_muzzles select 0);
		player setVariable ["d_player_backpack", [_primary, _mags_with_ammocount, _primary_items, _loadedmags_with_ammocount]];
		if (alive player) then {d_backpack_helper = []};
	};
};

d_in_backpack = nil;