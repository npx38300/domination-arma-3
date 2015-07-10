// by Xeno
#define THIS_FILE "fn_make_isle_grp.sqf"
#include "x_setup.sqf"

__TRACE("Starting _make_isle_grp")
private ["_units", "_start_point", "_dc", "_agrp", "_vecs", "_rand", "_npos"];
_dc = 0;
_start_point = [d_with_isledefense select 0,d_with_isledefense select 1,d_with_isledefense select 2,d_with_isledefense select 3] call d_fnc_GetRanPointSquare;
while {(count _start_point < 3 || {(_start_point distance d_FLAG_BASE < 2000)} || {(_start_point distance d_old_old_start < 500)}) && {_dc < 99}} do {
	_start_point = [d_with_isledefense select 0,d_with_isledefense select 1,d_with_isledefense select 2,d_with_isledefense select 3] call d_fnc_GetRanPointSquare;
	sleep 0.353;
	_dc = _dc + 1;
};
_start_point = _start_point call d_fnc_WorldBoundsCheck;
__TRACE_1("","_start_point")
sleep 0.01;
d_old_old_start = _start_point;
_units = [];
_vecs = [];
_agrp = [d_side_enemy] call d_fnc_creategroup;
_npos = _start_point;
{
	_rand = floor random 2;
	if (_rand > 0) then {
		_reta = [_rand,_npos,_x select 0,_agrp,-1.111] call d_fnc_makevgroup;
		_vecs = [_vecs, _reta select 0] call d_fnc_arrayPushStack;
		_units = [_units, _reta select 1] call d_fnc_arrayPushStack;
		sleep 0.73;
		_npos = ((_reta select 0) select 0) modelToWorld [0,-12,0];
	};
} forEach ([d_enemy_side] call d_fnc_getmixedlist);
sleep 0.31;

_agrp setVariable ["d_PATR", true];
_agrp setVariable ["d_PATR_ISLE", true];
[_agrp, _start_point, [d_with_isledefense select 0, d_with_isledefense select 1, d_with_isledefense select 2, d_with_isledefense select 3]] spawn d_fnc_MakePatrolWPX;
if (d_searchintel select 5 == 1) then {
	_agrp spawn d_fnc_IsleDefMarkerMove;
};
[_agrp, _units, [0,0,0], _vecs]