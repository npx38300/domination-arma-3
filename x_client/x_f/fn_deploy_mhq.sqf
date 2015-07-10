// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_deploy_mhq.sqf"
#include "x_setup.sqf"
private ["_mhq", "_depltime", "_camo"];

__TRACE("Starting")

if (isDedicated || {!alive player} || {isNil "d_curvec_dialog"} || {isNull d_curvec_dialog} || {!alive d_curvec_dialog}) exitWith {
	__TRACE("Exiting deply_mhq 1")
};

_mhq = objNull;
_dd = 599;
{
	if (!isNull _x && {!(_x isKindOf "ParachuteBase")} && {!(_x isKindOf "BIS_Steerable_Parachute")} && {(_x getVariable ["d_vec_type", ""]) == "MHQ"}) then {
		_distt = _x distance player;
		if (_distt < _dd) then {
			_mhq = _x;
			_dd = _distt;
		};
	};
} forEach ((getPosATLVisual player) nearEntities [["LandVehicle", "Air"], 10]);

if (isNull _mhq) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_1451")};

if ([d_base_trigger, getPosATLVisual _mhq] call bis_fnc_inTrigger || {surfaceIsWater (getPosATLVisual d_curvec_dialog)}) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_213")};

if ((_mhq getVariable ["d_MHQ_Depltime", -1]) > time) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_214")};

__TRACE("Before reading deploy var")

if !(_mhq getVariable ["d_MHQ_Deployed", false]) then {
	__TRACE("MHQ not deployed")
	if !(_mhq call d_fnc_GetVehicleEmpty) exitWith {
		systemChat (localize "STR_DOM_MISSIONSTRING_215");
		__TRACE("MHQ not empty")
	};

	if (d_with_mhq_camo == 0) then {
		["d_mhq_net", _mhq] call d_fnc_netcalleventcts;
	};
	_mhq setVariable ["d_MHQ_Deployed", true, true];
	["d_mhqdepl", [_mhq, true]] call d_fnc_NetCallEvent;
	_mhq setVariable ["d_MHQ_Depltime", time + 10, true];
} else {
	__TRACE("MHQ deployed")
	_camo = _mhq getVariable ["d_MHQ_Camo", objNull];
	if (!isNull _camo) then {deleteVehicle _camo};
	_mhq setVariable ["d_MHQ_Deployed", false, true];
	["d_mhqdepl", [_mhq, false]] call d_fnc_NetCallEvent;
	_mhq setVariable ["d_MHQ_Depltime", time + 10, true];
};

__TRACE("End")