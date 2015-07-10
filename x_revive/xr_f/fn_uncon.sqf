// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_uncon.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_disp", "_curtime"];
disableSerialization;
enableRadio false;
["xr_addActions", player] call d_fnc_NetCallEventToClients;
if (!captive player) then {
	["xr_setCap", [player,true]] call d_fnc_NetCallEvent;
};

#define __dspctrl(ctrlid) (_disp displayCtrl ctrlid)
closeDialog 0;
xr_respawn_available = false;
_curtime = time;
player setVariable ["xr_unconendtime", _curtime + xr_lifetime];
player setVariable ["xr_hasusedmapclickspawn", false];
xr_u_ott = -1;
xr_u_respawn = if (xr_respawn_available_after != -1) then {
	_curtime + xr_respawn_available_after
} else {
	xr_respawn_available = true; -1
};

__TRACE_2("","_curtime","xr_u_respawn")

[true] spawn xr_fnc_spectating;

xr_u_pl_died = false;
xr_u_dcounter = 0;
__TRACE("starting main loop")
xr_u_remactions = false;
xr_u_nextcrytime = time + 15 + (random 15);
if (xr_with_marker) then {
	__TRACE("creating marker")
	["xr_umarker", [player, getPosASL player]] call d_fnc_NetCallEventCTS;
};
xr_u_xxstarttime = time + 40;
xr_u_plposm = getPosASL player;
__TRACE_1("","xr_u_plposm")

xr_u_doend_of = false;

__TRACE("starting main uncon loop")
["itemAdd", ["dom_xr_uncon_of", {
	if (!xr_u_doend_of && {alive player} && {player getVariable "xr_pluncon"}) then {
		call xr_fnc_uncon_oneframe;
	} else {
		["itemRemove", ["dom_xr_uncon_of"]] call bis_fnc_loop;
		
		xr_u_dcounter = nil;
		xr_u_xxstarttime = nil;
		xr_u_plposm = nil;
		xr_u_ott = nil;
		xr_u_respawn = nil;
		xr_u_nextcrytime = nil;
		xr_u_doend_of = nil;
		
		0 spawn {
			if (!xr_u_remactions) then {
				__TRACE("xr_u_remactions")
				["xr_removeActions", player] call d_fnc_NetCallEventToClients;
			};
			if (xr_with_marker) then {
				__TRACE("del marker")
				["d_d_m_g", xr_strpldead] call d_fnc_NetCallEventCTS;
			};
			__TRACE("set capture false player")
			["xr_setCap", [player,false]] call d_fnc_NetCallEvent;
			enableRadio true;
			__TRACE_1("","xr_u_pl_died")
			if (!xr_u_pl_died) then {
				if (!(player getVariable "xr_hasusedmapclickspawn")) then {
					__TRACE("player alive and lives left, black out")
					172 cutText ["","BLACK OUT", 1];
				};
				sleep 1;
				if (!(player getVariable "xr_hasusedmapclickspawn")) then {
					__TRACE("Sending 102")
					["xr_wn", [player,102]] call d_fnc_NetCallEvent;
				};
				player setDamage 0;
				d_x_loop_end = true;
				closeDialog 0;
				if (!xr_stopspect) then {
					__TRACE("stopspect = true")
					xr_stopspect = true;
				};
				if (!(player getVariable "xr_hasusedmapclickspawn")) then {
					__TRACE("player alive and lives left, black in")
					172 cutText ["","BLACK IN", 6];
					if (xr_max_lives != -1) then {
						0 spawn {
							sleep 7;
							hintSilent format [localize "STR_DOM_MISSIONSTRING_933", player getVariable "xr_lives"];
						};
					};
				};
			};
			__TRACE("after if !u_pl_died")
			xr_u_pl_died = nil;
			player setFatigue 0;
			player enableFatigue false;
			bis_fnc_feedback_burningTimer = 0;
			call xr_fnc_joingr;
			bis_fnc_feedback_allowPP = true;
			d_DomCommandingMenuBlocked = false;
			d_commandingMenuIniting = false;
			showCommandingMenu "";
		};
		__TRACE("uncon ended, one frame removed")
	};
}, 0.02]] call bis_fnc_loop;
