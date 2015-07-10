// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_handledisconnect.sqf"
#include "x_setup.sqf"
if (!isServer) exitWith{};
private ["_id","_uid", "_pa", "_mname", "_unit"];

_unit = [_this, 0] call BIS_fnc_param;
_id = [_this, 1] call BIS_fnc_param;
_uid = [_this, 2] call BIS_fnc_param;

__TRACE_3("","_unit","_id","_uid")

if (!isNil "d_HC_CLIENT_OBJ" && {!isNull d_HC_CLIENT_OBJ} && {_unit == d_HC_CLIENT_OBJ}) exitWith {
	d_HC_CLIENT_OBJ = nil;
	d_HC_CLIENT_OBJ_NAME = nil;
	d_HC_CLIENT_READY = nil;
	false;
};

_pa = d_player_store getVariable _uid;
if (!isNil "_pa") then {
	__TRACE_1("player store before change","_pa")
	_pa set [0, if ((time - (_pa select 1)) >= (_pa select 0)) then {0} else {(_pa select 0) - (time - (_pa select 1))}];
	_pa set [9, time];
	_mname = (_pa select 4) + "_xr_dead";
	__TRACE_1("","_mname")
	if (markerType _mname != "") then {
		deleteMarker _mname;
	};
	_amark = _pa select 10;
	__TRACE_1("","_amark")
	if (_amark != "") then {
		if (markerType _amark != "") then {
			deleteMarker _amark;
		};
		_pa set [10, ""];
	};
	(_pa select 4) call d_fnc_markercheck;
	__TRACE_1("player store after change","_pa")
};

_unit spawn {
	sleep 10;
	deleteVehicle _this;
};
false