//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_startclientscripts.sqf"
#include "x_setup.sqf"

if (isDedicated || {!alive player} || {(player getVariable 'xr_pluncon')}) exitWith {};
private ["_vec", "_type", "_wtime", "_minutes"];
if (!(d_clientScriptsAr select 0) && {(isMultiplayer && {d_pisadminp}) || {!isMultiplayer}} && {alive player} && {!(player getVariable 'xr_pluncon')}) then {
	d_clientScriptsAr set [0, true];
	player setVariable ["d_p_isadmin", true];
	execFSM "fsms\isAdmin.fsm";
};
if (!(d_clientScriptsAr select 1) && {!isNil "d_player_autokick_time"}) then {
	if (isNil "d_nomercyendtime") then {
		d_nomercyendtime = time + d_player_autokick_time;
		if (d_player_autokick_time <= 0) exitWith {
			d_clientScriptsAr set [1, true];
			d_player_autokick_time = nil;
			d_nomercyendtime = nil;
		};
	} else {
		if (time >= d_nomercyendtime) exitWith {
			d_clientScriptsAr set [1, true];
			d_player_autokick_time = nil;
			d_nomercyendtime = nil;
		};
		_vec = vehicle player;
		if (_vec != player && {_vec isKindOf "Air"}) then {
			_type = typeOf _vec;
			if ((toUpper(_type) in d_mt_bonus_vehicle_array || {toUpper(_type) in d_sm_bonus_vehicle_array}) && {(player == driver _vec || {player == gunner _vec} || {player == commander _vec})}) then {
				player action ["getOut", _vec];
				_type_name = [_type, "CfgVehicles"] call d_fnc_GetDisplayName;
				_wtime = d_nomercyendtime - time;
				_minutes = round (_wtime / 60);
				if (_minutes < 1) then {_minutes = 1};
				[format [localize "STR_DOM_MISSIONSTRING_1416", _type_name, _minutes], "HQ"] call d_fnc_HintChatMsg;
			};
		};
	};
};