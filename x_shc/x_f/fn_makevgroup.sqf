// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makevgroup.sqf"
#include "x_setup.sqf"

private ["_numvecs", "_pos", "_vname", "_grp", "_direction", "_crews", "_grpskill", "_vec", "_npos", "_the_vecs", "_nnvnum", "_toupvname"];
_numvecs = [_this, 0] call BIS_fnc_param;
_pos = [_this, 1] call BIS_fnc_param;
_vname = [_this, 2] call BIS_fnc_param;
_grp = [_this, 3] call BIS_fnc_param;
_direction = [_this, 4] call BIS_fnc_param;
_the_vecs = [];
_crews = [];
_npos = _pos;

__TRACE_1("","_this")

_grpskill = if (_vname isKindOf "StaticWeapon") then {1.0} else {(d_skill_array select 0) + (random (d_skill_array select 1))};

_toupvname = toUpper _vname;
_the_vecs resize _numvecs;
_nnvnum = _numvecs - 1;
for "_n" from 0 to _nnvnum do {
	__TRACE_1("","_npos")
	_vec_ar = [_npos, (if (_direction != -1.111) then {_direction} else {floor random 360}), _vname, _grp] call d_fnc_spawnVehicle;
	_vec = _vec_ar select 0;
	_crews = [_crews, _vec_ar select 1] call d_fnc_arrayPushStack;
	
	_the_vecs set [_n, _vec];
	if (_n < _nnvnum) then {
		_npos = _vec modelToWorld [0,-12,0];
	};
	
	if !(_toupvname in d_heli_wreck_lift_types) then {
		_vec addEventHandler ["killed", {_this call d_fnc_handleDeadVec}];
		d_allunits_add pushBack _vec;
	};
	if (d_LockArmored == 0 && {_vec isKindOf "Tank"}) then {
		_vec lock true;
	} else {
		if (d_LockCars == 0 && {_vec isKindOf "Wheeled_APC" || {_vec isKindOf "Wheeled_APC_F"} || {_vec isKindOf "Car"}}) then {
			_vec lock true;
		} else {
			if (d_LockAir == 0 && {_vec isKindOf "Air"}) then {_vec lock true};
		};
	};
	if (d_with_ai && {d_with_ranked}) then {_vec addMPEventHandler ["MPkilled", {if (isServer) then {[5,_this select 1] call d_fnc_AddKillsAI;(_this select 0) removeAllMPEventHandlers "MPKilled"}}]};
};
(leader _grp) setSkill _grpskill;
[_grp, 1] call d_fnc_setGState;
[_the_vecs, _crews]