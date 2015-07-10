// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_revive\xr_main.sqf"
#include "xr_macros.sqf"

if (isNil "xr_with_marker") then {
	xr_with_marker = true;
};

[0, "xr_wn", {_this call xr_fnc_handlenet}] call d_fnc_NetAddEvent;
[0, "xr_setCap", {(_this select 0) setCaptive (_this select 1)}] call d_fnc_NetAddEvent;
[0, "xr_a1", {_this switchMove "ainjpfalmstpsnonwrfldnon_carried_up"}] call d_fnc_NetAddEvent;
[0, "xr_a2", {_this switchMove "acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon"}] call d_fnc_NetAddEvent;
[0, "xr_a3", {_this switchMove "AinjPpneMstpSnonWrflDnon"}] call d_fnc_NetAddEvent;
[0, "xr_a4", {_this switchMove "unconscious"}] call d_fnc_NetAddEvent;
[0, "xr_sd", {_this setDir 180}] call d_fnc_NetAddEvent;
if (!isDedicated) then {
	["xr_cpr", {player setVariable ["xr_unconendtime", (player getVariable "xr_unconendtime") + xr_cpr_time_add]}] call d_fnc_NetAddEventSTO;
};
if (d_sub_kill_points != 0) then {
	if (d_sub_kill_points > 0) then {d_sub_kill_points = d_sub_kill_points * -1};
	["xr_add_sub_kill", {_this addScore d_sub_kill_points}] call d_fnc_NetAddEventCTS;
};
["xr_msg", {
	if ((_this select 2) == side (group player) && {(_this select 1) != xr_name_player}) then {
		systemChat format [localize "STR_DOM_MISSIONSTRING_913", _this select 1, _this select 0];
	};
	if ((_this select 1) == xr_name_player) then {
		_this spawn {
			sleep 2.5;
			systemChat (format [localize "STR_DOM_MISSIONSTRING_914", _this select 0]);
		};
	};
}] call d_fnc_NetAddEventToClients;
[0, "xr_wn2", {if (local (_this select 0)) then {_this call xr_fnc_handlenet}}] call d_fnc_NetAddEvent;
["xr_addActions", {if (player != _this) then {_this call xr_fnc_addActions}}] call d_fnc_NetAddEventToClients;
["xr_removeActions", {if (player != _this) then {_this call xr_fnc_removeActions}}] call d_fnc_NetAddEventToClients;

xr_moansoundsar = [
	[
		"Person0",
		[
			"P0_moan_13_words.wss", "P0_moan_14_words.wss", "P0_moan_15_words.wss", "P0_moan_16_words.wss",
			"P0_moan_17_words.wss", "P0_moan_18_words.wss", "P0_moan_19_words.wss", "P0_moan_20_words.wss"
		]
	],
	[
		"Person1",
		[
			"P1_moan_19_words.wss", "P1_moan_20_words.wss", "P1_moan_21_words.wss", "P1_moan_22_words.wss",
			"P1_moan_23_words.wss", "P1_moan_24_words.wss", "P1_moan_25_words.wss", "P1_moan_26_words.wss",
			"P1_moan_27_words.wss", "P1_moan_28_words.wss", "P1_moan_29_words.wss", "P1_moan_30_words.wss",
			"P1_moan_31_words.wss", "P1_moan_32_words.wss", "P1_moan_33_words.wss"
		]
	],
	[
		"Person2",
		[
			"P2_moan_14_words.wss", "P2_moan_15_words.wss", "P2_moan_16_words.wss", "P2_moan_17_words.wss",
			"P2_moan_18_words.wss", "P2_moan_19_words.wss", "P2_moan_20_words.wss", "P2_moan_21_words.wss"
		]
	],
	[
		"Person3",
		[
			"P3_moan_10_words.wss", "P3_moan_11_words.wss", "P3_moan_12_words.wss", "P3_moan_13_words.wss",
			"P3_moan_14_words.wss", "P3_moan_15_words.wss", "P3_moan_16_words.wss", "P3_moan_17_words.wss",
			"P3_moan_18_words.wss", "P3_moan_19_words.wss", "P3_moan_20_words.wss"
		]
	]
];

if (xr_with_marker && {isServer}) then {
	["xr_umarker", {_this call xr_fnc_addmarker}] call d_fnc_NetAddEventCTS;
};

if (isDedicated) exitWith {};

if (isNil "xr_respawn_available_after") then {xr_respawn_available_after = 150};
if (isNil "xr_near_player_dist") then {xr_near_player_dist = 250};
if (isNil "xr_lifetime") then {xr_lifetime = 300};
if (isNil "xr_can_revive") then {xr_can_revive = []};

xr_dropAction = -3333;
if (isNil "xr_phd_invulnerable") then {xr_phd_invulnerable = false};

if (xr_selfheals > 0) then {
	0 spawn {
		scriptName "spawn_xr_selfheal";
		private "_id";
		while {true} do {
			player setVariable ["xr_numheals", xr_selfheals];
			waitUntil {alive player};
			_id = player addAction ["<t color='#FF0000'>Self Heal</t>", {_this call xr_fnc_selfheal}, [], -1, false, false, "", "alive _target &&  {!(_target getVariable 'xr_pluncon')} && {!(_target getVariable 'xr_pisinaction')} && {(damage _target >= (xr_selfheals_minmaxdam select 0))} && {(damage _target <= (xr_selfheals_minmaxdam select 1))} && {(_target getVariable 'xr_numheals') > 0}"];
			waitUntil {!alive player};
			player removeAction _id;
		};
	};
};
