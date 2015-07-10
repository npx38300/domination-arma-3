#define THIS_FILE "x_revive.sqf"
#include "xr_macros.sqf";


// units that can revive, use var name as string like in player entities or empty array so that anybody can revive
// if a unit can't revive another one it can at least enhance the lifetime with CPR menu entry
xr_can_revive = if (d_only_medics_canrevive == 0) then {
	["d_alpha_6", "d_bravo_6", "d_charlie_6", "d_echo_6"]
} else {
	[]
};

// set max lives to -1 to have unlimited lives
if (isNil "xr_max_lives") then {
	xr_max_lives = 30;
};

// show markers on map where unit died
xr_with_marker = true;

// life time once unconscious
if (isNil "xr_lifetime") then {
	xr_lifetime = 300;
};

// map click respawn available after x seconds, -1 for immedeate respawn
if (isNil "xr_respawn_available_after") then {
	xr_respawn_available_after = 120;
};

// list players only if they are x meters avway
xr_near_player_dist = 250;

// respawn available when no other players in near_player_dist
xr_near_player_dist_respawn = true;

// set the number of bonus lifes a player gets when he revives another player, 0 to disable it
xr_help_bonus = 1;

// if set to false no "x was revived by y" message will show up
xr_revivemsg = true;

// if a player can not revive another unit he can at least use CPR. cpr_time_add gets added to the other units livetime
xr_cpr_time_add = 300;

// selfheals, how often a player can heal himself (0 = disabled)
xr_selfheals = 0;
// if selfheals is enabled then if damage player >= 0.3 and <= 0.7 the action shows up
xr_selfheals_minmaxdam = [0.3, 0.7];

call compile preprocessFileLineNumbers "x_revive\xr_main.sqf";

execVM "x_revive\xr_init.sqf";
