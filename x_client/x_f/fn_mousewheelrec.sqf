//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_mousewheelrec.sqf"
#include "x_setup.sqf"

if (isDedicated || {!isNil "d_is_sat_on"}) exitWith {false};

private ["_ct", "_role", "_rpic", "_t", "_ctrl", "_dospawn", "_sidepp", "_crewct"];
if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {false};
_ct = if (vehicle player == player) then {
	cursorTarget
} else {
	vehicle player
};

if (isNull _ct || {!alive _ct} || {_ct distance player > 20} || {(!(_ct isKindOf "Car") && {!(_ct isKindOf "Tank")} && {!(_ct isKindOf "Air")})} || {_ct isKindOf "ParachuteBase"} || {_ct isKindOf "UAV_01_base_F"} || {_ct isKindOf "UGV_01_base_F"} || {_ct isKindOf "UAV_02_base_F"} || {getNumber(configFile/"CfgVehicles"/typeOf _ct/"isBicycle") == 1} || {(_ct call d_fnc_GetAliveCrew) == 0}) exitWith {false};
_sidepp = side (group player);
_crewct = crew _ct;
if ({alive _x && {_sidepp getFriend side (group _x) >= 0.6}} count _crewct == 0) exitWith {false};

_ar_P = [];
_ar_AI = [];
{
	if (alive _x) then {
		if (isPlayer _x) then {
			_ar_P pushBack _x;
		} else {
			_ar_AI pushBack _x;
		};
	};
} forEach _crewct;

_s_p = "";
if !(_ar_P isEqualTo []) then {
	_s_p = "<t color='#b5f279' align='right'>";
	{
		_role = assignedVehicleRole _x;
		if !(_role isEqualTo []) then {
			private "_rpic";
			if (commander _ct == _x) then {
				_rpic = "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa";
			} else {
				if (driver _ct == _x) then {
					_rpic = "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa";
				} else {
					_rpic = switch (toUpper (_role select 0)) do {
						case "TURRET": {"\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa"};
						default {"\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_cargo_ca.paa"};
					};
				};
			};
			_s_p = _s_p + (name _x) + "<img color='#FFFFFF' image='" + _rpic + "'/> " + "<br/>";
		};
	} forEach _ar_P;
	_s_p = _s_p + "</t>";
};

_s_ai = "";
if !(_ar_AI isEqualTo []) then {
	_s_ai = "<t color='#b5f279' align='right'>";
	{
		_role = assignedVehicleRole _x;
		if !(_role isEqualTo []) then {
			private "_rpic";
			_rpic = if (commander _ct == _x) then {
				"\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa"
			} else {
				if (driver _ct == _x) then {
					"\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa"
				} else {
					if (_role select 0 == "DRIVER") then {
						"\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa"
					} else {
						if (_role select 0 == "TURRET") then {
							"\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa"
						} else {
							"\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_cargo_ca.paa"
						};
					};
				};
			};
			_s_ai = _s_ai + (name _x) + " (AI)" + "<img color='#FFFFFF' image='" + _rpic + "'/> " + "<br/>";
		};
	} forEach _ar_AI;
	_s_ai = _s_ai + "</t>";
};

_t = "<t color='#FFFFFF' size='1'><t align='right'>" + (localize "STR_DOM_MISSIONSTRING_538") + " " + ([typeOf _ct, "CfgVehicles"] call d_fnc_GetDisplayName) + ":</t>" + "<br/>" + _s_p + _s_ai;// + "</t>";
121282 cutRsc ["d_rscCrewText", "PLAIN"];
_ctrl = (uiNamespace getVariable "d_rscCrewText") displayCtrl 9999;
_ctrl ctrlSetStructuredText parseText _t;
_ctrl ctrlCommit 0;
_dospawn = d_rscCrewTextShownTimeEnd == -1;
d_rscCrewTextShownTimeEnd = time + 5;
if (_dospawn) then {
	0 spawn {
		scriptName "spawn_crewrsc";
		private "_vecp";
		_vecp = vehicle player;
		waitUntil {sleep 0.221;time > d_rscCrewTextShownTimeEnd || {!alive player} || {player getVariable ["xr_pluncon", false]} || {vehicle player != _vecp}};
		121282 cutRsc ["d_Empty", "PLAIN"];
		d_rscCrewTextShownTimeEnd = -1;
	};
};