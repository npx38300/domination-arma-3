// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_heli_local_check.sqf"
#include "x_setup.sqf"

private ["_local", "_chopper", "_lon", "_ropes", "_lobm"];
_local = [_this, 1] call BIS_fnc_param;

__TRACE_1("","_local")

if (!_local) exitWith {};

_chopper = [_this, 0] call BIS_fnc_param;

__TRACE_1("","_chopper")

_lon = _chopper getVariable "d_mhq_lift_obj";
__TRACE_1("","_lon")
if (!isNil "_lon") then {
	_lobj = _lon select 0;
	if (!isNil "_lobj" && {alive _lobj}) then {
		_lobj setVariable ["d_in_air", false, true];
		d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "Dmr_available",["1","",_lon select 1,[]],"GLOBAL"];
	};
	if (alive _chopper) then {
		_chopper setVariable ["d_mhq_lift_obj", nil, true];
	};
};

_ropes = _chopper getVariable "d_ropes";
__TRACE_1("","_ropes")
if (!isNil "_ropes") then {
	{
		if (!isNull _x) then {
			ropeDestroy _x;
		};
	} forEach _ropes;
};

_dummy = _chopper getVariable "d_dummy_lw";
__TRACE_1("","_dummy")
if (!isNil "_dummy") then {
	deleteVehicle _dummy;
	_chopper setVariable ["d_dummy_lw", nil, true];
};

if (alive _chopper) then {
	_chopper setVariable ["d_ropes", nil, true];
};

_lobm = _chopper getVariable "d_lobm";
__TRACE_1("","_lobm")
if (!isNil "_lobm") then {
	["d_setmass", _lobm] call d_fnc_NetCallEvent;
	if (alive _chopper) then {
		_chopper setVariable ["d_lobm", nil, true];
	};
};
