// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_revive\xr_init.sqf"
#include "xr_macros.sqf"

if (!isNil "xr_INIT") exitWith {};
xr_INIT = false;

if (!isDedicated) then {
	if (isNull player) then {
		0 spawn {waitUntil {!isNull player};xr_INIT = true};
	} else {
		xr_INIT = true;
	};
};

if (isDedicated) exitWith {};

waitUntil {xr_INIT};
waitUntil {player == player};

player setVariable ["xr_lives", xr_max_lives];
player setVariable ["xr_num_death", 0];
player setVariable ["xr_is_dragging", false];
player setVariable ["xr_presptime", -1];
player setVariable ["xr_busyt", -1, true];
player setVariable ["xr_pluncon", false, true];
player setVariable ["xr_pisinaction", false];
player setVariable ["xr_death_pos", []];
player setVariable ["xr_dragged", false, true];
player setVariable ["xr_isdead", false];

xr_pl_group = group player;
xr_side_pl = if (!isNull xr_pl_group) then {side xr_pl_group} else {playerSide};

xr_strpl = str player;
xr_strpldead = xr_strpl + "_xr_dead";

player addEventHandler ["killed", {_this call xr_fnc_killedEH}];

player addEventHandler ["respawn", {_this call xr_fnc_respawneh}];

xr_name_player = name player;

player setVariable ["d_phd_eh", player addEventHandler ["handleDamage", {_this call xr_fnc_ClientHD}]];

if (xr_can_revive isEqualTo []) then {
	xr_pl_can_revive = true;
} else {
	{
		xr_can_revive set [_forEachIndex, toUpper _x];
	} forEach xr_can_revive;
	xr_pl_can_revive = (toUpper(str player) in xr_can_revive);
};

{
	_unit = missionNamespace getVariable _x;
	if (!isNil "_unit") then {
		if (alive _unit && {_unit getVariable ["xr_pluncon", false]}) then {
			_unit call xr_fnc_addActions;
		} else {
			_unit setVariable ["xr_ReviveAction", -9999];
			_unit setVariable ["xr_DragAction", -9999];
		};
	};
} forEach d_player_entities;
