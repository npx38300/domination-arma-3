//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_createinf.sqf"
#include "x_setup.sqf"

private ["_radius", "_pos", "_nr", "_nrg", "_typenr", "_i", "_newgroup", "_units", "_pos_center", "_do_patrol", "_ret_grps"];
_pos_center = _this select 4;
_radius = _this select 5;
_do_patrol = if (_radius < 50) then {false} else {if (count _this == 7) then {_this select 6} else {false}};

_ret_grps = [];
_pos = [];

for "_nr" from 0 to 1 do {
	_nrg = _this select (1 + (_nr * 2));
	if (_nrg > 0) then {
		if (d_MissionType == 2) then {_nrg = _nrg + 2};
		_typenr = _this select (_nr * 2);
		for "_i" from 1 to _nrg do {
			_newgroup = [d_side_enemy] call d_fnc_creategroup;
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
			_units = [_pos, ([_typenr, d_enemy_side] call d_fnc_getunitlist) select 0, _newgroup] call d_fnc_makemgroup;
			_newgroup allowFleeing 0;
			if (!_do_patrol) then {
				_newgroup setCombatMode "YELLOW";
				_newgroup setFormation (["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","DIAMOND"] call d_fnc_RandomArrayVal);
				_newgroup setFormDir (floor random 360);
				_newgroup setSpeedMode "NORMAL";
				_newgroup setVariable ["d_defend", true];
				[_newgroup, _pos_center] spawn d_fnc_taskDefend;
			} else {
				[_newgroup, _pos, [_pos_center, _radius], [5, 15, 30], ""] spawn d_fnc_MakePatrolWPX;
			};
			_ret_grps pushBack _newgroup;
			d_x_sm_rem_ar = [d_x_sm_rem_ar, _units] call d_fnc_arrayPushStack;
		};
	};
};
_ret_grps