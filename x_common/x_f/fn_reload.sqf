// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_reload.sqf"
#include "x_setup.sqf"
private ["_config","_count","_i","_magazines","_object","_type","_type_name"];

#define __NOALIEX if (!alive _object) exitWith {};
#define __NOALIEX2 if (!alive _object) exitWith {[]};

_object = [_this, 0] call BIS_fnc_param;
__TRACE_1("","_object")
if (typeName _object == "ARRAY") then {
	_obb = objNull;
	{
		if ((_x isKindOf "Helicopter" || {_x isKindOf "LandVehicle"} || {_x isKindOf "Plane"}) && {!(_x isKindOf "HeliH")} && {!(_x isKindOf "Land_HelipadSquare_F")}) exitWith {
			_obb = _x;
		};
	} forEach _object;
	_object = _obb;
};

if (isNull _object || {_object isKindOf "ParachuteBase"}) exitWith {};

_type = typeof _object;
__TRACE_2("","_object","_type")

_lrl = _object getVariable ["d_last_reload", -1];
if (_lrl != -1 && {(time - _lrl) < 60}) exitWith {
	if (!isDedicated) then {
		_object vehicleChat format [localize "STR_DOM_MISSIONSTRING_699", round (60 - (time - _lrl))];
	};
};
_object setVariable ["d_last_reload", time];

if (isNil "d_reload_time_factor") then {d_reload_time_factor = 1};

__NOALIEX
_object setFuel 0;

_type_name = [_type, "CfgVehicles"] call d_fnc_GetDisplayName;
if (_type_name == "") then {_type_name = _type};
if (!isDedicated) then {_object vehicleChat format [localize "STR_DOM_MISSIONSTRING_701", _type_name]};

#ifdef __DEBUG__
_magazinesxx = _object magazinesTurret [0];
__TRACE_1("","_magazinesxx")
#endif

_cfgturrets = configFile/"CfgVehicles"/_type/"Turrets";

__TRACE_1("","_cfgturrets")

_fillTurrets = {
	if (count _this < 1) exitWith {[]};
	private ["_entry", "_path"];
	_entry = [_this, 0] call BIS_fnc_param;
	_path = [_this, 1] call BIS_fnc_param;
	_object = [_this, 2] call BIS_fnc_param;
	if (typeName _entry != typeName configFile) exitWith {[]};
	private ["_turrets", "_turretIndex","_thisTurret"];
	_turrets = [];
	_turretIndex = 0;
	for "_i" from 0 to (count _entry - 1) do {
		private "_subEntry";
		_subEntry = _entry select _i;
		__TRACE_1("","_subEntry")
		if (isClass _subEntry) then {
			private "_hasGunner";
			_hasGunner = [_subEntry, "hasGunner"] call bis_fnc_returnConfigEntry;
			__TRACE_1("","_hasGunner")
			if (!isNil "_hasGunner" && {_hasGunner == 1}) then {
				_thisTurret = _path + [_turretIndex];
				__TRACE_2("","_object","_thisTurret")
				private ["_fullmags", "_magazinesx", "_removedX"];
				_fullmags = getArray (_subEntry/"magazines");
				__TRACE_3("","_subEntry","_fullmags","_thisTurret")
				if (_object turretLocal _thisTurret) then {
					_magazinesx = _object magazinesTurret _thisTurret;
					__TRACE_2("","_thisTurret","_magazinesx")
					_removedX = [];
					{
						if !(_x in _removedX) then {
							_object removeMagazinesTurret [_x, _thisTurret];
							_removedX pushBack _x;
						};
					} forEach _magazinesx;
					__TRACE_1("","_removedX")
				};
				__NOALIEX2
				{
					private "_mag_disp_name";
					_mag_disp_name = [_x, "CfgMagazines"] call d_fnc_GetDisplayName;
					if (_mag_disp_name == "") then {_mag_disp_name = _x};
					if (!isDedicated) then {_object vehicleChat format [localize "STR_DOM_MISSIONSTRING_702", _mag_disp_name]};
					sleep d_reload_time_factor;
					__NOALIEX2
					__TRACE_1("","_x")
					if (_object turretLocal _thisTurret) then {
						_object addMagazineTurret [_x, _thisTurret];
					};
					sleep d_reload_time_factor;
					__NOALIEX2
				} forEach _fullmags;
				__NOALIEX2
				_turrets pushBack _turretIndex;
				if (isClass (_subEntry/"Turrets")) then {
					_turrets pushBack ([_subEntry/"Turrets",_thisTurret, _object] call _fillTurrets);
				} else {
					_turrets pushBack [];
				};
				__NOALIEX2
			};
			_turretIndex = _turretIndex + 1;
			__NOALIEX2
		};
		__NOALIEX2
	};
	__TRACE_1("_fillTurrets","_turrets")
	_turrets
};

if !(_cfgturrets isEqualTo []) then {
	[_cfgturrets,[], _object] call _fillTurrets;
};

__NOALIEX

_magazines = getArray(configFile/"CfgVehicles"/_type/"magazines");
__TRACE_1("","_magazines")

if !(_magazines isEqualTo []) then {
	_removed = [];
	{
		if !(_x in _removed) then {
			_object removeMagazines _x;
			_removed pushBack _x;
			__TRACE_1("remMag","_x")
		};
	} forEach _magazines;
	__TRACE_1("","_removed")
	{
		if (!isDedicated) then {_object vehicleChat format [localize "STR_DOM_MISSIONSTRING_702", _x]};
		sleep d_reload_time_factor;
		__NOALIEX
		_object addMagazine _x;
		__TRACE_1("addMag","_x")
	} forEach _magazines;
};
_object setVehicleAmmo 1;

__NOALIEX

sleep d_reload_time_factor;
__NOALIEX
if (!isDedicated) then {_object vehicleChat (localize "STR_DOM_MISSIONSTRING_704")};
_object setDamage 0;
sleep d_reload_time_factor;
__NOALIEX
if (!isDedicated) then {_object vehicleChat (localize "STR_DOM_MISSIONSTRING_705")};
while {fuel _object < 0.99} do {
	_object setFuel 1;
	sleep 0.01;
};
sleep d_reload_time_factor;
__NOALIEX
if (!isDedicated) then {_object vehicleChat format [localize "STR_DOM_MISSIONSTRING_706", _type_name]};

reload _object;