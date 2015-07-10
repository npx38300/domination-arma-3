// by Xeno
// #define __DEBUG__
#define THIS_FILE "x_revive\xr_f\fn_selfheal.sqf"

#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_endtime"];

player setVariable ["xr_pisinaction", true];

_ma = "ainvpknlmstpslaywrfldnon_medic";
player playMove _ma;
_endtime = time + 12;
waitUntil {animationState player == _ma || {!alive player} || {player getVariable "xr_pluncon"} || {time > _endtime}};
waitUntil {animationState player != _ma || {!alive player} || {player getVariable "xr_pluncon"} || {time > _endtime}};

if (alive player && {!(player getVariable "xr_pluncon")}) then {
	player setDamage 0;
	player setVariable ["xr_overall", 0];
	player setVariable ["xr_head_hit", 0];
	player setVariable ["xr_body", 0];
	player setVariable ["xr_hands", 0];
	player setVariable ["xr_legs", 0];
	player setVariable ["xr_hand_l", 0];
	player setVariable ["xr_leg_l", 0];
	player setVariable ["xr_numheals", (player getVariable "xr_numheals") - 1];
};

player setVariable ["xr_pisinaction", false];
