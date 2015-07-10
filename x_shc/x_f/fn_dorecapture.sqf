// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_dorecapture.sqf"
#include "x_setup.sqf"
private ["_radius", "_helih", "_veclist", "_unitslist", "_posran", "_reta", "_vecs", "_units", "_completel", "_target_center", "_recap_index", "_counter"];
if !(call d_fnc_checkSHC) exitWith {};

__TRACE_1("","_this")

_target_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_recap_index = [_this, 2] call BIS_fnc_param;
_helih = [_this, 3] call BIS_fnc_param;

__TRACE_3("","_target_center","_radius","_recap_index")
__TRACE_1("","_helih")

_veclist = [];
_unitslist = [];

{
	_posran = [_target_center, _radius] call d_fnc_GetRanPointCircleNoSlope;
	__TRACE_1("vec","_posran")
	_counter = 0;
	while {_posran isEqualTo [] && {_counter < 50}} do {
		_posran = [_target_center, _radius] call d_fnc_GetRanPointCircleNoSlope;
		__TRACE_1("in loop vec","_posran")
		_counter = _counter + 1;
		sleep 0.4;
	};
	if (_posran isEqualTo []) then {
		_posran = [_target_center, _radius] call d_fnc_GetRanPointCircleOld;
	};
	_reta = [ceil (random 2), _posran, ([_x, d_enemy_side] call d_fnc_getunitlist) select 1, [d_side_enemy] call d_fnc_creategroup, -1.111] call d_fnc_makevgroup;
	_vecs = _reta select 0;
	__TRACE_2("","_reta","_vecs")
	{_x lock true} forEach _vecs;
	sleep 0.1;
	_veclist = [_veclist, _vecs] call d_fnc_arrayPushStack;
	_unitslist = [_unitslist, _reta select 1] call d_fnc_arrayPushStack;
	__TRACE_2("","_veclist","_unitslist")
	sleep 0.1;
} forEach ["tank","tracked_apc"];

__TRACE_2("","_veclist","_unitslist")

sleep 1.23;

for "_i" from 0 to 1 do {
	_posran = [_target_center, _radius] call d_fnc_GetRanPointCircleNoSlope;
	__TRACE_1("men","_posran")
	_counter = 0;
	 while {_posran isEqualTo [] && {_counter < 50}} do {
		_posran = [_target_center, _radius] call d_fnc_GetRanPointCircleNoSlope;
		__TRACE_1("in loop men","_posran")
		_counter = _counter + 1;
		sleep 0.4;
	};
	if (_posran isEqualTo []) then {
		_posran = [_target_center, _radius] call d_fnc_GetRanPointCircleOld;
	};
	_units = [_posran, (["basic", d_enemy_side] call d_fnc_getunitlist) select 0, [d_side_enemy] call d_fnc_creategroup] call d_fnc_makemgroup;
	_unitslist = [_unitslist, _units] call d_fnc_arrayPushStack;
	__TRACE_2("","_units","_unitslist")
	sleep 0.1;
};

__TRACE_2("","_units","_unitslist")

sleep 10;

_completel = _unitslist;
_completel = [_completel, _veclist] call d_fnc_arrayPushStack;
__TRACE_1("","_completel")
while {(_completel call d_fnc_GetAliveUnits) > 5} do {
#ifdef __DEBUG__
	diag_log [_completel call d_fnc_GetAliveUnits];
#endif
	sleep 10.312
};

sleep 5;

_helih setVariable ["d_recaptured", nil, true];

d_recapture_indices = d_recapture_indices - [_recap_index];

_target_name = (d_target_names select _recap_index) select 1;
["d_s_mrecap_g", [_target_name, "ColorGreen", "Solid"]] call d_fnc_NetCallEventCTS;
["d_recaptured", [_recap_index, 1]] call d_fnc_NetCallEventToClients;
["d_kbmsg", [22, _target_name, _target_name]] call d_fnc_NetCallEventCTS;

sleep 300;

{
	if (!isNull _x) then {
		_x call d_fnc_DelVecAndCrew;
	};
} forEach _veclist;

{if (!isNull _x) then {deleteVehicle _x}} forEach _unitslist;
