// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makegroup.sqf"
#include "x_setup.sqf"
private ["_grptype", "_numvecs", "_type", "_side", "_vehicles", "_grp", "_pos", "_unitsinf", "_min", "_max", "_mid", "_wp_array", "_target_pos", "_grp_in", "_vec_dir", "_add_to_ar_type", "_center_rad", "_unit_array"];

if !(call d_fnc_checkSHC) exitWith {};

_grptype = [_this, 0] call BIS_fnc_param;
_wp_array = [_this, 1] call BIS_fnc_param;
_target_pos = [_this, 2] call BIS_fnc_param;
_numvecs = [_this, 3] call BIS_fnc_param;
_type = [_this, 4] call BIS_fnc_param;
_side = [_this, 5] call BIS_fnc_param;
_grp_in = [_this, 6] call BIS_fnc_param;
_vec_dir = [_this, 7] call BIS_fnc_param;
_add_to_ar_type = [_this, 8, 0] call BIS_fnc_param; // respawn 0 = nothing, 1 = main target group, 2 = attack group
_center_rad = [_this, 9, []] call BIS_fnc_param;

__TRACE_1("","_center_rad")
_vehicles = [];
_unitsinf = [];

_grp = if (typeName _grp_in == typeName 0) then {[_side] call d_fnc_creategroup} else {_grp_in};
_pos = if (count _wp_array > 1) then {_wp_array call d_fnc_RandomArrayVal} else {_wp_array select 0};

__TRACE_1("","_grp")

_unit_array = [_grptype, _side] call d_fnc_getunitlist;

if (_numvecs > 0) then {
	_vehicles = [_vehicles, ([_numvecs, _pos, _unit_array select 1, _grp, _vec_dir] call d_fnc_makevgroup) select 0] call d_fnc_arrayPushStack;
	_grp setSpeedMode "LIMITED";
} else {
	_unitsinf = [_pos, _unit_array select 0, _grp] call d_fnc_makemgroup;
};

if (_add_to_ar_type > 0) then {
	if !(_grptype in ["stat_mg", "stat_gl", "arty"]) then { // don't add static weapons !!!!, respawn doesn't make sense, they can't travel from the respawn camp to another location
		_add_ar = [_grp, [_grptype, [], _target_pos, _numvecs, "patrol2", _side, 0, _vec_dir, _add_to_ar_type, _center_rad, d_enemyai_respawn_pos]];
		__TRACE_1("","_add_ar")
		d_respawn_ai_groups pushBack _add_ar;
	};
	if !(_vehicles isEqualTo []) then {
		d_delvecsmt = [d_delvecsmt, _vehicles] call d_fnc_arrayPushStack;
	};
	if !(_unitsinf isEqualTo []) then {
		d_delinfsm = [d_delinfsm, _unitsinf] call d_fnc_arrayPushStack;
	};
};

_unit_array = nil;
_grp allowFleeing (((floor random 3) + 1) / 10);

switch (_type) do {
	case "patrol": {
		_grp setVariable ["d_PATR",true];
		_min = 1 + random 15;
		_max = _min + (1 + random 15);
		_mid = _min + (random (_max - _min));
		[_grp, _pos, _center_rad, [_min, _mid, _max], ""] call d_fnc_MakePatrolWPX;
	};
	case "patrol2mt": {
		_grp setVariable ["d_PATR",true];
		_min = 1 + random 15;
		_max = _min + (1 + random 15);
		_mid = _min + (random (_max - _min));
		[_grp, _pos, _center_rad, [_min, _mid, _max], ""] call d_fnc_MakePatrolWPX;
	};
	case "patrol2": {
		_grp setVariable ["d_PATR",true];
		_min = 1 + random 15;
		_max = _min + (1 + random 15);
		_mid = _min + (random (_max - _min));
		[_grp, _pos, _center_rad, [_min, _mid, _max], ""] call d_fnc_MakePatrolWPX2;
	};
	case "guard": {
		if (_grptype == "basic" || {_grptype == "specops"}) then {
			_grp setVariable ["d_defend", true];
			[_grp, _pos] spawn d_fnc_taskDefend;
		} else {
			_grp call d_fnc_GuardWP;
		};
	};
	case "guardstatic": {
		if (_grptype == "basic" || {_grptype == "specops"}) then {
			_grp setVariable ["d_defend", true];
			[_grp, _pos] spawn d_fnc_taskDefend;
		} else {
			_grp call d_fnc_GuardWP;
		};
	};
	case "guardstatic2": {
		(_vehicles select 0) setDir (floor random 360);
	};
	case "attack": {
		[_grp, _target_pos] call d_fnc_AttackWP;
	};
};

_vehicles = nil;