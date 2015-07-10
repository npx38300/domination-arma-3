//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_respawneh.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_old", "_d_pos"];
_old = _this select 1;
__TRACE_1("","_old")
_mpos = markerPos "xr_resp_marker";
__TRACE_1("","_mpos")
player setPos _mpos;
if (player getVariable "xr_isdead") exitWith {};
__TRACE("playActionNow Die")
player playActionNow "Die"; // takes loooong
player setVariable ["xr_pluncon", true, true]; // just to be sure
_norm_resp = false;
if ((player getVariable "xr_death_pos") isEqualTo []) then {
	_norm_resp = true;
	_old call xr_fnc_CheckRespawn;
};
deleteVehicle _old;
__TRACE_1("","_norm_resp")
["xr_setCap", [player,true]] call d_fnc_NetCallEvent;
_d_pos = player getVariable "xr_death_pos";
__TRACE_1("","_d_pos")
if !(_d_pos isEqualTo []) then {
	__TRACE("pos to old pos and dir")
	player setDir (_d_pos select 1);
	player setPos (_d_pos select 0);
	if (!_norm_resp) then {
		0 spawn xr_fnc_uncon;
		if (xr_with_marker) then {
			["xr_umarker", [player, getPosASL player]] call d_fnc_NetCallEventCTS;
		};
	} else {
		__TRACE("spawning go uncon")
		0 spawn {
			if (surfaceIsWater (getPosASL player)) then {
				__TRACE("respawneh spawn watferfix check start")
				private "_shandle";
				_shandle = 0 spawn xr_fnc_waterfix;
				waitUntil {scriptDone _shandle};
				__TRACE("respawneh spawn watferfix done")
			};
			private ["_pos", "_slope"];
			waitUntil {speed player < 0.5};
			_pos = getPosATL player;
			_slope = [_pos, 1] call d_fnc_GetSlope;
			__TRACE_2("respawneh spawn","_pos","_slope")
			if (_slope >= 0.78) then {
				__TRACE("respawneh spawn in slope, new position")
				[_pos, _slope, player] call xr_fnc_DoSlope;
			};
			0 spawn xr_fnc_uncon;
		};
	};
};
player setVariable ["xr_pisinaction", false];
player setVariable ["xr_is_dragging", false];
player setVariable ["xr_dragged", false, true];
player setVariable ["xr_busyt", -1, true];

0 spawn {
	_etime = time + 5;
	waitUntil {bis_fnc_feedback_allowPP || {time > _etime}};
	bis_fnc_feedback_allowPP = false;
};
player setDamage 0;
bis_fnc_feedback_burningTimer = 0;
player setFatigue 0;
player enableFatigue false;
vehicle player addAction ["<t color='#FF0000'>Server Rules</t>", "Server_Rules.sqf", [], 0, true, true, "", "vehicle _this == vehicle _target"];