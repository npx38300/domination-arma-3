// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_uncon_oneframe.sqf"
#include "xr_macros.sqf"

#define __spectdlg1005 ((uiNamespace getVariable "xr_SpectDlg") displayCtrl 1005)
#define __spectdlg1006 ((uiNamespace getVariable "xr_SpectDlg") displayCtrl 1006)

if (time >= xr_u_nextcrytime) then {
	_plsayer = floor (random 4);
	_nummoans = floor (random (count ((xr_moansoundsar select _plsayer) select 1)));
	__TRACE_2("next say","_plsayer","_nummoans")
	//playSound3D ["a3\sounds_f\characters\human-sfx\" + ((xr_moansoundsar select _plsayer) select 0) + "\" + (((xr_moansoundsar select _plsayer) select 1) select _nummoans), player, false, getPosASL player, 1, 1, 100];
	playSound3D ["a3\sounds_f\characters\human-sfx\" + ((xr_moansoundsar select _plsayer) select 0) + "\" + (((xr_moansoundsar select _plsayer) select 1) select _nummoans), player, false, [0,0,0], 1, 1, 100];
	xr_u_nextcrytime = time + 15 + (random 15);
};
private "_tt";
_tt = round ((player getVariable "xr_unconendtime") - time);
if (_tt != xr_u_ott) then {
	__spectdlg1005 ctrlSetText str _tt;
	xr_u_ott = _tt;
};
if (xr_near_player_dist_respawn && {!xr_respawn_available} && {xr_u_dcounter > 10} && {time > xr_u_xxstarttime}) then {
	_nearunit = objNull;
	{
		_xm = missionNamespace getVariable _x;
		if (!isNil "_xm" && {_x != xr_strpl} && {!isNull _xm} && {!(_xm getVariable ["xr_pluncon", false])} && {_xm distance player < xr_near_player_dist}) exitWith {
			_nearunit = _xm;
		};
	} forEach d_player_entities;
	if (isNull _nearunit) then {
		xr_respawn_available = true;
		__spectdlg1006 ctrlSetText (localize "STR_DOM_MISSIONSTRING_922");
		__spectdlg1006 ctrlSetTextColor [1,1,0,1];
		__spectdlg1006 ctrlCommit 0;
	};
	xr_u_dcounter = 0;
} else {
	xr_u_dcounter = xr_u_dcounter + 1;
	if (xr_u_dcounter > 1000) then {xr_u_dcounter = 0};
};
if (xr_u_respawn != -1 && {!xr_respawn_available} && {time >= xr_u_respawn}) then {
	__spectdlg1006 ctrlSetText (localize "STR_DOM_MISSIONSTRING_922");
	__spectdlg1006 ctrlSetTextColor [1,1,0,1];
	__spectdlg1006 ctrlCommit 0;
	xr_respawn_available = true;
};
if (_tt <= 0) exitWith {
	__TRACE("_tt < =0, exit")
	if (xr_with_marker) then {
		["d_d_m_g", xr_strpldead] call d_fnc_NetCallEventCTS;
	};
	["xr_removeActions", player] call d_fnc_NetCallEventToClients;
	xr_u_remactions = true;
	__TRACE("_tt <= 0, black out")
	172 cutText [localize "STR_DOM_MISSIONSTRING_932", "BLACK OUT", 1];
	0 spawn {
		sleep 1;
		closeDialog 0;
		__TRACE("_tt stopspect = true")
		xr_stopspect = true;
		sleep 1.3;
		player setPos (markerPos "base_spawn_1");
		player setDamage 0;
		["xr_wn", [player,105]] call d_fnc_NetCallEvent;
		if (!isNil "d_custom_layout" && {!(d_custom_layout isEqualTo [])}) then {
			call d_fnc_retrieve_layoutgear;
		};
		sleep 1.3;
		__TRACE("time over black in")
		172 cutText ["","BLACK IN", 2];
		xr_pl_has_pos_changed = false;
		player setVariable ["xr_pluncon", false, true];
		if (xr_max_lives != -1) then {
			0 spawn {
				sleep 3;
				hintSilent format [localize "STR_DOM_MISSIONSTRING_933", player getVariable "xr_lives"];
			};
		};
		xr_u_pl_died = true;
	};
	xr_u_doend_of = true;
};
if (xr_with_marker) then {
	// adjust marker if uncon player gets moved. Can happen when he gets dragged/carried or when a apc hits him (flying miles away)
	_newplposm = getPosASL player;
	if (_newplposm distance xr_u_plposm > 5) then {
		__TRACE_2("","xr_u_plposm","_newplposm")
		xr_u_plposm = _newplposm;
		xr_strpldead setMarkerPos _newplposm;
	};
};
