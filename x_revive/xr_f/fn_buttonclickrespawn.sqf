//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_buttonclickrespawn.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_respawn_pos","_etime", "_mhq", "_mhqobj", "_getcusbp"];
__TRACE(", black out")
172 cutText [localize "STR_DOM_MISSIONSTRING_917", "BLACK OUT", 0.2];

player setVariable ["xr_hasusedmapclickspawn", true];

if (d_beam_target == "D_BASE_D") then {
	_respawn_pos = markerPos "base_spawn_1";
} else {
	_mrs = missionNamespace getVariable [d_beam_target, objNull];
	_respawn_pos = _mrs modelToWorldVisual [0,-7,0];
	_respawn_pos set [2,0];
	_global_dir = getDirVisual _mrs;
	_typepos = 1;
};

__TRACE_1("","_respawn_pos")

sleep 1;
__TRACE("stopspect = true")
xr_stopspect = true;
player setVariable ["xr_pluncon", false, true];
["xr_setCap", [player, false]] call d_fnc_NetCallEvent;
//["xr_wn", [player,105]] call d_fnc_NetCallEvent;
sleep 0.5;

_getcusbp = {
	if (!isNil "d_custom_layout" && {!(d_custom_layout isEqualTo [])}) then {
		call d_fnc_retrieve_layoutgear;
		_cusbp = player getVariable ["d_custom_backpack", []];
		if !(_cusbp isEqualTo []) then {
			player setVariable ["d_player_backpack", _cusbp];
		};
	};
};

_nos = _respawn_pos nearEntities ["All", 25];
__TRACE_1("","_nos")
_mhqobj = objNull;
{
	if (_x getVariable ["d_vec_type", ""] == "MHQ") exitWith {
		_mhqobj = _x;
	};
} forEach _nos;
["xr_wn", [player, 105]] call d_fnc_NetCallEvent;
__TRACE_1("","_mhqobj")
if (!isNull _mhqobj) then {
	_newppos = _mhqobj modelToWorldVisual [0,-7,0];
	player setDir (getDirVisual _mhqobj);
	player setPosATL [_newppos select 0, _newppos select 1, 0];
	_nobs = nearestObjects [player, d_rev_respawn_vec_types, 30];
	{player reveal _x} forEach _nobs;
	call _getcusbp;
} else {
	call _getcusbp;
	if (surfaceIsWater _respawn_pos) then {
		player setPosASL [markerpos "base_spawn_1" select 0, markerpos "base_spawn_1" select 1, 16.20];
	} else {
		player setPos _respawn_pos;
	};
};
player setDamage 0;
__TRACE("MapClickRespawn, black in")
172 cutText [localize "STR_DOM_MISSIONSTRING_918", "BLACK IN", 6];
if (xr_max_lives != -1) then {
	0 spawn {
		sleep 7;
		hintSilent format [localize "STR_DOM_MISSIONSTRING_933", player getVariable "xr_lives"];
		if (d_with_ai && {alive player} && {!(player getVariable ["xr_pluncon", false])}) then {[] spawn d_fnc_moveai};
	};
};
__TRACE("MapClickRespawn done")