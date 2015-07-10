// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_docreatenexttarget.sqf"
#include "x_setup.sqf"
private ["_counter", "_tmppos", "_dirn","_cur_tgt_pos", "_cur_tgt_radius"];
if (count _this == 2) then {
	_cur_tgt_pos = [_this, 0] call BIS_fnc_param;
	_cur_tgt_radius = [_this, 1] call BIS_fnc_param;
} else {
	_cur_tgt_pos = [_this, 1] call BIS_fnc_param;
	_cur_tgt_radius = [_this, 2] call BIS_fnc_param;
	d_target_radius = [_this, 3] call BIS_fnc_param;
	d_mttarget_radius_patrol = [_this, 4] call BIS_fnc_param;
};

if (isServer && {!isNil "d_HC_CLIENT_OBJ"}) exitWith {
	["d_docnt", [d_HC_CLIENT_OBJ, _cur_tgt_pos, _cur_tgt_radius, d_target_radius, d_mttarget_radius_patrol]] call d_fnc_NetCallEventSTO;
};

d_delvecsmt = [];
d_delinfsm = [];
d_respawn_ai_groups = [];
d_mt_done = false;

d_enemyai_respawn_pos = [getPosASL d_FLAG_BASE, _cur_tgt_pos] call d_fnc_posbehind2; // startpoint for random camp location (if needed) plus direction
if (surfaceIsWater (d_enemyai_respawn_pos select 0)) then {
	__TRACE("Position is in water")
	private ["_counter", "_tmppos", "_dirn" ,"_dist"];
	_counter = 0;
	_tmppos = d_enemyai_respawn_pos select 0;
	__TRACE_1("","d_enemyai_respawn_pos")
	_dist = d_enemyai_respawn_pos select 2;
	_dirn = d_enemyai_respawn_pos select 1;
	if (_dirn < 0) then {_dirn = _dirn + 180};
	_incdir = if (_dirn <= 90 || {_dirn >= 270}) then {
		-15
	} else {
		15
	};
	__TRACE_3("","_dist","_dirn","_incdir")
	_foundpos = false;
	while {_counter < 2} do {
		for "_i" from 1 to 8 do {
			_ndir = _dirn + (_incdir * _i);
			_x1 = (_cur_tgt_pos select 0) - (_dist * sin _ndir);
			_y1 = (_cur_tgt_pos select 1) - (_dist * cos _ndir);
			if (!surfaceIsWater [_x1, _y1]) exitWith {
				_tmppos = [_x1, _y1, 0];
				_foundpos = true;
			};
		};
		if (_foundpos) exitWith {
			__TRACE_1("","_tmppos")
		};
		_counter = _counter + 1;
		_incdir = _incdir * -1;
	};
	
	if (surfaceIsWater _tmppos) then {
		_tmppos = _cur_tgt_pos;
	};
	
	d_enemyai_respawn_pos set [0, _tmppos];
	_dirn = [_cur_tgt_pos, _tmppos] call d_fnc_DirTo;
	_dirn = _dirn + 180;
	d_enemyai_respawn_pos set [2, _dirn];
};

d_enemyai_mt_camp_pos = [d_enemyai_respawn_pos select 0, 600, 400, d_enemyai_respawn_pos select 1] call d_fnc_GetRanPointSquare;
#ifdef __GROUPDEBUG__
if (markerType "enemyai_mt_camp_pos" != "") then {deleteMarkerLocal "enemyai_mt_camp_pos"};
["enemyai_mt_camp_pos",d_enemyai_mt_camp_pos,"ICON","ColorBlack",[1,1],"enemy camp pos",0,"mil_dot"] call d_fnc_CreateMarkerLocal;
#endif

[_cur_tgt_pos, _cur_tgt_radius] spawn d_fnc_createmaintarget;