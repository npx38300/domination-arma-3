// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_clienthd.sqf"
#include "xr_macros.sqf"

#define __shots ["shotBullet","shotShell","shotRocket","shotMissile","shotTimeBomb","shotMine","shotGrenade","shotSpread","shotSubmunitions","shotDeploy","shotBoundingMine","shotDirectionalBomb"]

if (isDedicated) exitWith {};

private ["_unit", "_part", "_dam", "_injurer", "_ammo"];
_unit = [_this, 0] call BIS_fnc_param;
_part = [_this, 1] call BIS_fnc_param;
_dam = [_this, 2] call BIS_fnc_param;
_injurer = [_this, 3] call BIS_fnc_param;
_ammo = [_this, 4] call BIS_fnc_param;
__TRACE_1("","_this")
if (!alive _unit || {_dam == 0}) exitWith {
	__TRACE_1("exiting, unit dead or healing","_dam")
	_dam
};
if (_unit getVariable ["xr_pluncon", false] || {xr_phd_invulnerable}) exitWith {
	__TRACE_2("exiting, unit uncon or invulnerable","_part")
	0
};
if (d_no_teamkill == 0 && {_dam >= 0.1} && {!isNull _injurer} && {isPlayer _injurer} && {_injurer != _unit} && {vehicle _unit == _unit} && {side (group _injurer) == side (group _unit)}) exitWith {
	if (_part == "" && {_ammo != ""} && {getText (configFile/"CfgAmmo"/_ammo/"simulation") in __shots} && {time > ((player getVariable "d_tk_cutofft") + 3)}) then {
		_unit setVariable ["d_tk_cutofft", time];
		hint format [localize "STR_DOM_MISSIONSTRING_497", name _injurer];
		["d_unit_tkr", [_unit,_injurer]] call d_fnc_NetCallEventCTS;
	};
	0
};
if (_dam >= 0.9 && {time > (_unit getVariable "d_last_gear_save")}) then {
	__TRACE_1("saving respawn gear","_dam")
	_unit setVariable ["d_last_gear_save", time + 2];
	call d_fnc_save_respawngear;
	_unit setVariable ["xr_isleader", leader (group player) == player];
	xr_pl_group = group player;
};
_dam