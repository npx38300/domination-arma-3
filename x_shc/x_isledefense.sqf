// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_isledefense.sqf"
#include "x_setup.sqf"
private ["_isle_grps", "_igrp", "_make_new", "_leader"];
if !(call d_fnc_checkSHC) exitWith {};

sleep 85.321;

__TRACE("before isServer check")

if (isServer && {!isNil "d_HC_CLIENT_OBJ"}) exitWith {};

__TRACE("after isServer check")

d_old_old_start = [0,0,0];

_isle_grps = [];
for "_i" from 1 to (d_with_isledefense select 4) do {
	_isle_grps pushBack (call d_fnc_make_isle_grp);
	sleep 3.012;
};
__TRACE_1("","_isle_grps")

while {true} do {
	call d_fnc_mpcheck;
	sleep 300 + random 300;
	{
		_igrp = _x select 0;
		_make_new = false;
		if (!isNull _igrp) then {
			if ((_igrp call d_fnc_GetAliveUnitsGrp) == 0) then {
				_make_new = true;
			} else {
				_leader = leader _igrp;
				if (!isNull _leader) then {
					if ((_x select 2) distance _leader < 100) then {
						_make_new = true;
					} else {
						_x set [2, getPosATL _leader];
					};
				};
			};
		} else {
			_make_new = true;
		};
		if (_make_new) then {
			{if (!isNull _x) then {_x call d_fnc_DelVecAndCrew};sleep 0.01} forEach (_x select 3);
			sleep 0.01;
			{if (!isNull _x) then {deleteVehicle _x};sleep 0.01} forEach (_x select 1);
			_isle_grps set [_forEachIndex, call d_fnc_make_isle_grp];
			sleep 3.012;
		};
		sleep 50 + random 50;
	} forEach _isle_grps;
};