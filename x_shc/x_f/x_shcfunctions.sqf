// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_shcfunctions.sqf"
#include "x_setup.sqf"

#ifdef __GROUPDEBUG__
// the group debug functions are not available in a mission release, no need to compile them with compileFinal
d_fnc_map_group_count_marker = {
	scriptName "d_fnc_map_group_count_marker";
	_mname = "all_groups_yeah";
	_mtext = "Groups: %1, alive units: %2, inf without leader: %3";
	[_mname, [3000,1000,0],"ICON","ColorBlack",[2,2],format [_mtext, 0,0],0,"mil_dot"] call d_fnc_CreateMarkerLocal;
	while {true} do {
		d_all_marker_groups = d_all_marker_groups - [objNull, grpNull];
		_grpcounter = count d_all_marker_groups;
		_units = 0;
		_remgrps = [];
		{
			_alu = _x call d_fnc_GetAliveUnitsGrp;
			if (_alu > 0) then {
				_units = _units + _alu;
			} else {
				_remgrps pushBack _x;
			};
		} forEach d_all_marker_groups;
		if (count _remgrps > 0) then {
			d_all_marker_groups = d_all_marker_groups - _remgrps;
		};
		_mname setMarkerTextLocal format [_mtext, _grpcounter,_units, d_infunitswithoutleader];
		sleep 1;
	};
};

d_gcounter = -1;
d_infunitswithoutleader = 0;
d_fnc_groupmarker = {
	scriptName "d_fnc_groupmarker";
	private ["_grp", "_mname", "_mnamel", "_leader", "_p1", "_wps", "_idx", "_curwppos", "_gname"];
	_grp = [_this, 0] call BIS_fnc_param;
	waitUntil {sleep 0.221;(_grp call d_fnc_GetAliveUnitsGrp) > 0};
	_helper = str _grp;
	_gname = if (_helper != "") then {_helper} else {d_gcounter = d_gcounter + 1;str d_gcounter};
	_mname = _gname + "dgrp";
	_mnamel = _mname + "lm";
	_mnamewp = _mname + "wpm";
	_gname = _gname;
	sleep 1;
	d_all_marker_groups pushBack _grp;
	_vec = vehicle leader _grp;
	_mtype = if (_vec == leader _grp) then {
		switch (side _grp) do {case blufor: {"b_inf"};case opfor: {"o_inf"};default {"n_inf"};}
	} else {
		switch (true) do {
			case (_vec isKindOf "Wheeled_APC" || {_vec isKindOf "Wheeled_APC_F"}): {switch (side _grp) do {case blufor: {"b_mech_inf"};case opfor: {"o_mech_inf"};default {"n_mech_inf"};}};
			case (_vec isKindOf "Car"): {switch (side _grp) do {case blufor: {"b_motor_inf"};case opfor: {"o_motor_inf"};default {"n_motor_inf"};}};
			case (_vec isKindOf "Tank"): {switch (side _grp) do {case blufor: {"b_armor"};case opfor: {"o_armor"};default {"n_armor"};}};
			case (_vec isKindOf "Helicopter"): {switch (side _grp) do {case blufor: {"b_air"};case opfor: {"o_air"};default {"n_air"};}};
			case (_vec isKindOf "Plane"): {switch (side _grp) do {case blufor: {"b_plane"};case opfor: {"o_plane"};default {"n_plane"};}};
			case (_vec isKindOf "StaticCannon"): {switch (side _grp) do {case blufor: {"b_art"};case opfor: {"o_art"};default {"n_art"};}};
			case (_vec isKindOf "StaticMortar"): {switch (side _grp) do {case blufor: {"b_mortar"};case opfor: {"o_mortar"};default {"n_mortar"};}};
			default {switch (side _grp) do {case blufor: {"b_support"};case opfor: {"o_support"};default {"n_support"};}};
		}
	};
	[_mname, [0,0,0],"ICON",(switch (side _grp) do {case opfor: {"ColorEAST"};case blufor: {"ColorWEST"};case independent: {"ColorGUER"};default {"ColorCIV"};}),[0.8,0.8],_gname,0,_mtype] call d_fnc_CreateMarkerLocal;
	_gname = _gname + " (%1)";
	while {true} do {
		if (isNull _grp || {(_grp call d_fnc_GetAliveUnitsGrp) == 0}) exitWith {
			deleteMarkerLocal _mname;
			deleteMarkerLocal _mnamel;
			deleteMarkerLocal _mnamewp;
		};
		_leader = leader _grp;
		if (!isNull _leader) then {
			_p1 = getPosASL _leader;
			_p1 set [2,0];
			_mname setMarkerPosLocal _p1;
			_mname setMarkerTextLocal format [_gname, _grp call d_fnc_GetAliveUnitsGrp];
			_wps = wayPoints _grp;
			_idx = currentWaypoint _grp;
			if (_idx > 0 && {_idx < count _wps}) then {
				_curwppos = waypointPosition (_wps select _idx);
				_curwppos set [2,0];
				_mpos = markerPos _mnamewp;
				if ((_mpos select 0) == 0 &&  {(_mpos select 1) == 0} && {(_mpos select 2) == 0}) then {
					[_mnamewp,_curwppos,"ICON","ColorGrey",[0.7, 0.7],"",0,"waypoint"] call d_fnc_CreateMarkerLocal;
				} else {
					_mnamewp setMarkerPosLocal _curwppos;
				};
				[_p1, _curwppos, _mnamel] call d_fnc_linemaker2;
			} else {
				deleteMarkerLocal _mnamel;
				deleteMarkerLocal _mnamewp;
			};
		} else {
			deleteMarkerLocal _mnamel;
			deleteMarkerLocal _mnamewp;
		};
		sleep (0.6 + random 0.2);
	};
};
#endif
