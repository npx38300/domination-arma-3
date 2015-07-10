//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_squadmgmtbuttonclicked.sqf"
#include "x_setup.sqf"

#define CTRL(A) (_disp displayCtrl A)

if (isDedicated || {d_sqtmgmtblocked}) exitWith {};
private ["_diff", "_grp", "_sidep", "_newgrp", "_count", "_oldgrp", "_disp", "_lbbox", "_lbidx", "_lbname"];
__TRACE_1("","_this")
if (typeName _this != typeName 1) exitWith {};
_diff = _this - 5000;
_grp = d_SQMGMT_grps select _diff;
_oldgrp = group player;
disableSerialization;
// remove unit from group
_disp = (uiNamespace getVariable "d_SquadManagementDialog");
_lbbox = 2000 + _diff;
__TRACE_1("","_lbbox")
_lbidx = lbCurSel CTRL(_lbbox);
_lbname = if (_lbidx != -1) then {
	CTRL(_lbbox) lbData _lbidx
} else {
	""
};
__TRACE_2("","_lbidx","_lbname")
_ogrlocked = _oldgrp getVariable ["d_locked", false];
if (_ogrlocked && {player == leader _oldgrp}) then {
	_oldgrp setVariable ["d_locked", false, true];
};
if (group player == _grp && {_lbidx != -1} && {_lbname != name player} && {player == leader _grp}) exitWith {
	_unittouse = objNull;
	{
		if (name _x == _lbname) exitWith {
			_unittouse = _x;
		};
	} forEach (units _grp);
	if (isNull _unittouse) exitWith {};
	// must be AI version
	if (!isPlayer _unittouse) exitWith {
		if (vehicle _unittouse == _unittouse) then {
			deleteVehicle _unittouse;
		} else {
			["d_delvc", [vehicle _unittouse, _unittouse]] call d_fnc_NetCallEventSTO;
		};
		if ((units _grp) isEqualTo [] && {!isNull _grp}) then {
			deleteGroup _grp;
		};
		if (dialog) then {
			call d_fnc_squadmanagementfill;
		};
	};
	_newgrpp = createGroup side (group player);
	[_unittouse] joinSilent _newgrpp;
	d_sqtmgmtblocked = true;
	__TRACE_1("1","_newgrpp")
	["d_grssrv", _newgrpp] call d_fnc_NetCallEventCTS;
	[_grp, _unittouse] spawn {
		scriptName "spawn_d_fnc_squadmgmtbuttonclicked_sqmgmtfill";
		waitUntil {!((_this select 1) in (units (_this select 1)))};
		if (dialog) then {
			call d_fnc_squadmanagementfill;
		};
		d_sqtmgmtblocked = false;
	};
};

// Leave = new group
if (group player == _grp) then {
	_sidep = side (group player);
	_newgrp = createGroup _sidep;
	[player] joinSilent _newgrp;
	__TRACE_1("2","_newgrp")
	["d_grssrv", _newgrp] call d_fnc_NetCallEventCTS;
	if (d_with_ai) then {
		_ai_only = true;
		{
			if (isPlayer _x) exitWith {
				_ai_only = false;
			};
		} forEach (units _grp);
		if (_ai_only) then {
			{
				deleteVehicle _x;
			} forEach (units _grp);
			if !((units _grp) isEqualTo []) then {
				{
					["d_delvc", [vehicle _x, _x]] call d_fnc_NetCallEventSTO;
				} forEach (units _grp)
			};
		};
	};
	if ((units _grp) isEqualTo []) then {
		if (!isNull _grp) then {
			deleteGroup _grp;
		};
	} else {
		if (player != leader _grp) then {
			["d_grpswmsg", [leader _grp, name player, player]] call d_fnc_NetCallEventSTO;
		};
		systemChat (localize "STR_DOM_MISSIONSTRING_1432a");
	};
	// transfer name of old group to new group ? (setgroup ID) ?
	// edit: not needed, players can't leave groups with just himself in the group
} else {
	_hasplay = {isPlayer _x} count (units _grp) > 0;
	__TRACE_1("","_hasplay")
	["d_grpjoin", [_grp, player]] call d_fnc_NetCallEventSTO;
	
	if (!_hasplay) then {
		["d_grpslead", [leader _grp, _grp, player]] call d_fnc_NetCallEventSTO;
	};
	
	if (d_with_ai) then {
		_ai_only = true;
		{
			if (isPlayer _x) exitWith {
				_ai_only = false;
			};
		} forEach (units _oldgrp);
		if (_ai_only) then {
			{
				deleteVehicle _x;
			} forEach (units _oldgrp);
			if !((units _oldgrp) isEqualTo []) then {
				{
					["d_delvc", [vehicle _x, _x]] call d_fnc_NetCallEventSTO;
				} forEach (units _oldgrp)
			};
		};
	};
	if ((units _oldgrp) isEqualTo [] && {!isNull _oldgrp}) then {
		deleteGroup _oldgrp;
	};
	if (!isNull _oldgrp && {player != leader _oldgrp}) then {
		["d_grpswmsg", [leader _oldgrp, name player]] call d_fnc_NetCallEventSTO;
	};
	if (player != leader _grp) then {
		["d_grpswmsgn", [leader _grp, name player]] call d_fnc_NetCallEventSTO;
	};
	systemChat (localize "STR_DOM_MISSIONSTRING_1432a");
};
d_sqtmgmtblocked = true;
_oldgrp spawn {
	scriptName "spawn_d_fnc_squadmgmtbuttonclicked_oldgrp";
	waitUntil {!(player in (units _this)) || {isNull _this}};
	if (dialog) then {
		call d_fnc_squadmanagementfill;
	};
	d_sqtmgmtblocked = false;
};