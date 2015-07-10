// by Xeno
#define THIS_FILE "fn_vec_hudsp.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_speed_str", "_fuel_str", "_dam_str", "_dir_str", "_gendirlist", "_vec", "_vec_string", "_vdir", "_gendir", "_type_weap", "_dirtmp", "_fuelcap"];
_speed_str = localize "STR_DOM_MISSIONSTRING_611";
_fuel_str = localize "STR_DOM_MISSIONSTRING_612";
_dam_str = localize "STR_DOM_MISSIONSTRING_613";
_dir_str = localize "STR_DOM_MISSIONSTRING_614";
_gendirlist = ["N", "N-NE", "NE", "E-NE", "E", "E-SE", "SE", "S-SE", "S", "S-SW", "SW", "W-SW", "W", "W-NW", "NW", "N-NW", "N"];

disableSerialization;

#define __CTRL(A) (_disp displayCtrl A)

_vec = vehicle player;
if (_vec isKindOf "LandVehicle" && {!(_vec isKindOf "StaticWeapon")}) then {
	_vtype = _vec getVariable ["d_vec_type", ""];
	if (_vtype == "MHQ" || {_vtype == "Engineer"}) then {
		[_vec, _vtype] spawn d_fnc_vec_welcome_message;
	};
	
	_fuelcap = getNumber(configFile/"CfgVehicles"/typeOf _vec/"fuelCapacity");
	while {d_player_in_vec && {alive player} && {!(player getVariable ["xr_pluncon", false])}} do {
		if (player == driver _vec || {player == gunner _vec} || {player == commander _vec}) then {
			_vec_string = localize "STR_DOM_MISSIONSTRING_631" + ([typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName);
			67327 cutRsc ["d_vehicle_hud", "PLAIN"];
			_disp = (uiNamespace getVariable "d_vehicle_hud");
			_ison = true;
			while {d_player_in_vec && {alive player} && {player == driver _vec}} do {
				_crewctrl = (uiNamespace getVariable "d_rscCrewText") displayCtrl 9999;
				_cctrlshown = if (isNil "_crewctrl") then {false} else {ctrlShown _crewctrl};
				if (!visibleMap && {!_cctrlshown}) then {
					if (!_ison) then {
						67327 cutRsc ["d_vehicle_hud", "PLAIN"];
						_disp = (uiNamespace getVariable "d_vehicle_hud");
						_ison = true;
					};
					
					__CTRL(64432) ctrlSetText _vec_string;
					__CTRL(64433) ctrlSetText format [_speed_str, round (speed _vec)];
					__CTRL(64434) ctrlSetText format [_fuel_str, round (fuel _vec * _fuelcap)];
					__CTRL(64435) ctrlSetText format [_dam_str, round (damage _vec * 100)];
					_vdir = round (getDirVisual _vec);
					_gendir = _gendirlist select (round (_vdir/22.5));
					__CTRL(64436) ctrlSetText format [_dir_str, _vdir, _gendir];
				} else {
					if (_ison) then {
						67327 cutRsc ["d_Empty", "PLAIN"];
						_ison = false;
					};
				};
				sleep 0.331;
			};
			67327 cutRsc["d_Empty", "PLAIN",1];
		};
		sleep 0.532;
	};
} else {
	if (_vec isKindOf "StaticWeapon" && {!(_vec isKindOf "StaticATWeapon")}) then {
		while {d_player_in_vec && {alive player} && {!(player getVariable ["xr_pluncon", false])}} do {
			if (player == gunner _vec) then {
				_vec_string = localize "STR_DOM_MISSIONSTRING_631" + ([typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName);
				_type_weap = (getArray(configFile/"CfgVehicles"/(typeOf _vec)/"Turrets"/"MainTurret"/"weapons")) select 0;
				67327 cutRsc ["d_vehicle_hud", "PLAIN"];
				_disp = (uiNamespace getVariable "d_vehicle_hud");
				_ison = true;
				while {d_player_in_vec && {alive player} && {player == gunner _vec}} do {
					_crewctrl = (uiNamespace getVariable "d_rscCrewText") displayCtrl 9999;
					_cctrlshown = if (isNil "_crewctrl") then {false} else {ctrlShown _crewctrl};
					if (!visibleMap && {!_cctrlshown}) then {
						if (!_ison) then {
							67327 cutRsc ["d_vehicle_hud", "PLAIN"];
							_disp = (uiNamespace getVariable "d_vehicle_hud");
							_ison = true;
						};
						__CTRL(64432) ctrlSetText _vec_string;
						__CTRL(64433) ctrlSetText format [_dam_str, round (damage _vec * 100)];
						_vecwdir = _vec weaponDirection _type_weap;
						_dirtmp = round((_vecwdir select 0) atan2 (_vecwdir select 1));
						if (_dirtmp < 0) then {_dirtmp = _dirtmp + 360};
						_gendir = _gendirlist select (round (_dirtmp/22.5));
						__CTRL(64434) ctrlSetText format [_dir_str, _dirtmp, _gendir];
						__CTRL(64435) ctrlSetText "";
						__CTRL(64436) ctrlSetText "";
					} else {
						if (_ison) then {
							67327 cutRsc ["d_Empty", "PLAIN"];
							_ison = false;
						};
					};
					sleep 0.331;
				};
				67327 cutRsc["d_Empty", "PLAIN",1];
			};
			sleep 0.532;
		};
	};
};
