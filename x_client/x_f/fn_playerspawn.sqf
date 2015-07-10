// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_playerspawn.sqf"
#include "x_setup.sqf"
#define __prma _p removeAction _id

if (isDedicated) exitWith {};

private ["_rtype", "_p", "_oabackpackmags", "_oabackpackweaps", "_ubp", "_ubackp", "_hasruck", "_ruckmags", "_ruckweapons", "_backwep", "_ident", "_id", "_types", "_type", "_ar", "_hh", "_primw", "_muzzles", "_bp", "_mags", "_mcount", "_i", "_weaps", "_s", "_action"];
_rtype = [_this, 0] call BIS_fnc_param;
__TRACE_1("","_rtype")

if (_rtype == 0) then { // player died
	if (visibleMap) then {
		openMap false;
	};
	if (d_WithRevive == 1) then {
		setPlayerRespawnTime 20;
	};
	if (d_WithRevive == 1) then {
		player setVariable ["d_is_leader", if (player == leader (group player)) then {group player} else {objNull}];
	};
	__TRACE("remove Dom handleDamage eh")
	player removeEventHandler ["handleDamage", player getVariable "d_phd_eh"];
	if (!isNil {player getVariable "d_ld_action"}) then {
		player removeAction (player getVariable "d_ld_action");
	};
} else { // _rtype = 1, player has respawned
	d_commandingMenuIniting = false;
	d_DomCommandingMenuBlocked = false;
	showCommandingMenu "";
	__TRACE("adding player handleDamage eventhandler")
	player setVariable ["d_phd_eh", player addEventHandler ["handleDamage", {_this call xr_fnc_ClientHD}]];
	xr_phd_invulnerable = true;
	player setFatigue 0;
	player enableFatigue false;
	_p = player;
	if (d_weapon_respawn) then {
		#define __addmx _p addMagazine _x
		#define __addwx _p addWeapon _x
		if (d_WithRevive == 1 && {!(d_custom_layout isEqualTo [])}) then {
			call d_fnc_retrieve_layoutgear;
			if (d_WithBackpack && {!((player getVariable "d_custom_backpack") isEqualTo [])}) then {
				player setVariable ["d_player_backpack", player getVariable "d_custom_backpack"];
			};
		} else {
			call d_fnc_retrieve_respawngear;
			if !(d_backpack_helper isEqualTo []) then {
				{__addmx} forEach (d_backpack_helper select 3);
				_p addWeapon (d_backpack_helper select 1);
				{__addmx} forEach (d_backpack_helper select 1);
				{if (_x != "") then {_p removePrimaryWeaponItem _x}} forEach (primaryWeaponItems _p);
				{if (_x != "") then {_p addPrimaryWeaponItem _x}} foreach (d_backpack_helper select 2);
				d_backpack_helper = [];
			};
		};
	};
	if (player getVariable ["d_has_gps", false]) then {
		player linkItem "ItemGPS";
		player setVariable ["d_has_gps", false];
	};
	// TODO "RadialBlurr" effect adjustment still needed?
	"RadialBlur" ppEffectAdjust [0.0, 0.0, 0.0, 0.0];
	"RadialBlur" ppEffectCommit 0;
	"RadialBlur" ppEffectEnable false;

	if (!isNil {player getVariable "d_bike_created"}) then {player setVariable ["d_bike_created", false]};
	
	if (d_WithRevive == 1) then {
		deleteVehicle ((_this select 1) select 1);
	};
	
	if (sunOrMoon < 0.99 && {_p call d_fnc_hasnvgoggles}) then {_p action ["NVGoggles",_p]};
	if !(_p getVariable ["xr_isdead", false]) then {
		0 spawn {
			scriptName "spawn_playerspawn_vul";
			waitUntil {!dialog};
			sleep 5;
			xr_phd_invulnerable = false;
		};
	};
	if (d_WithRevive == 1 && {!isNull (player getVariable "d_is_leader")}) then {
		["d_grpl", [player getVariable "d_is_leader", player]] call d_fnc_NetCallEventSTO;
	};
	_clattachedobj = player getVariable ["d_p_clattachedobj", objNull];
	if (!isNull _clattachedobj) then {
		_clattachedobj attachTo [player, [0,-0.03,0.07], "LeftShoulder"]; 
	};
	if (d_with_ai || {d_with_ai_features == 0} || {d_string_player in d_can_use_artillery} || {d_string_player in d_can_mark_artillery}) then {
		player setVariable ["d_ld_action", player addAction [(localize "STR_DOM_MISSIONSTRING_1520") call d_fnc_RedText, {_this call d_fnc_mark_artillery} , 0, 9, true, false, "", "alive player && {!(player getVariable ['xr_pluncon', false])} && {!(player getVariable ['d_isinaction', false])} && {!d_player_in_vec} && {currentWeapon  player == 'LaserDesignator'} && {cameraView == 'GUNNER'} && {!isNull (laserTarget player)}"]];
	};
};