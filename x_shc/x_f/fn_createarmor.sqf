// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createarmor.sqf"
#include "x_setup.sqf"

__TRACE_1("","_this")

private ["_radius", "_pos", "_nrg", "_typenr", "_newgroup", "_reta", "_pos_center", "_do_patrol", "_ret_grps"];
_pos_center = _this select 6;
_radius = _this select 8;
_do_patrol = if (_radius < 50) then {false} else {if (count _this == 10) then {_this select 9} else {false}};
__TRACE_3("","_pos_center","_radius","_do_patrol")
_ret_grps = [];
_pos = [];

for "_nr" from 0 to 2 do {
	_nrg = _this select (1 + (_nr * 2));
	__TRACE_1("","_nrg")
	if (_nrg > 0) then {
		if (d_MissionType == 2) then {_nrg = _nrg + 2};
		_typenr = _this select (_nr * 2);
		__TRACE_1("","_typenr")
		for "_i" from 1 to _nrg do {
			_newgroup = [d_side_enemy] call d_fnc_creategroup;
			__TRACE_1("","_newgroup")
			if (_radius > 0) then {
				_pos = [_pos_center, _radius] call d_fnc_GetRanPointCircle;
				if (_pos isEqualTo []) then {
					for "_ee" from 0 to 99 do {_pos = [_pos_center, _radius] call d_fnc_GetRanPointCircle;if !(_pos isEqualTo []) exitWith {}};
				};
				if (_pos isEqualTo []) then {
					_pos = _pos_center;
				};
			} else {
				_pos = _pos_center;
			};
			__TRACE_1("","_pos")
			_reta = [_this select 7, _pos, ([_typenr, d_enemy_side] call d_fnc_getunitlist) select 1, _newgroup, -1.111] call d_fnc_makevgroup;
			__TRACE_1("","_reta")
			d_x_sm_vec_rem_ar = [d_x_sm_vec_rem_ar, _reta select 0] call d_fnc_arrayPushStack;
			d_x_sm_rem_ar = [d_x_sm_rem_ar, _reta select 1] call d_fnc_arrayPushStack;
			_newgroup allowFleeing 0;
			if (!_do_patrol) then {
				_newgroup setCombatMode "YELLOW";
				_newgroup setFormation (["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","DIAMOND"] call d_fnc_RandomArrayVal);
				_newgroup setFormDir (floor random 360);
				_newgroup setSpeedMode "NORMAL";
			} else {
				[_newgroup, _pos, [_pos_center, _radius], [5, 15, 30]] spawn d_fnc_MakePatrolWPX;
			};
			_ret_grps pushBack _newgroup;
		};
	};
};
_ret_grps