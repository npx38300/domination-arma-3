// d_init include server
#ifndef __XSETUP_INCL__
#define THIS_FILE "i_server.sqf"
#include "x_setup.sqf"
#endif

d_bap_counter = 0;
d_bonus_create_pos = markerPos "d_bonus_create_pos";
deleteMarker "d_bonus_create_pos";
d_bonus_air_positions = [];
for "_i" from 1 to 10000 do {
	_mna = format ["d_bonus_air_positions_%1", _i];
	if (markerType _mna == "") exitWith {};
	d_bonus_air_positions pushBack [markerPos _mna, markerDir _mna];
	deleteMarker _mna;
};

d_bvp_counter = 0;
d_bonus_vec_positions = [];
for "_i" from 1 to 10000 do {
	_mna = format ["d_bonus_vec_positions_%1", _i];
	if (markerType _mna == "") exitWith {};
	d_bonus_vec_positions pushBack [markerPos _mna, markerDir _mna];
	deleteMarker _mna;
};

// add some random patrols on the island
// if the array is empty, no patrols
// simply place a rectangular marker called "d_isledefense_marker", marker text = number of patrols
if (d_WithIsleDefense == 0) then {
	_mname = "d_isledefense_marker";
	if (markerType _mname == "") exitWith {
		d_with_isledefense = [];
	};
	d_with_isledefense = [markerPos _mname, (markerSize _mname) select 0, (markerSize _mname) select 1, markerDir _mname, parseNumber (markerText _mname)];
	deleteMarker _mname;
} else {
	d_with_isledefense = [];
};

__TRACE_1("","d_with_isledefense")

if (d_MissionType != 2) then {
	0 spawn {
		scriptName "spawn_ServicePoint_Building";
		_pos = (d_service_buildings select 0) select 0;
		_dir = (d_service_buildings select 0) select 1;
		_fac = createVehicle [d_servicepoint_building, _pos, [], 0, "NONE"];
		_fac setDir _dir;
		_fac setPos _pos;

		_pos = (d_service_buildings select 1) select 0;
		_dir = (d_service_buildings select 1) select 1;
		_fac = createVehicle [d_servicepoint_building, _pos, [], 0, "NONE"];
		_fac setDir _dir;
		_fac setPos _pos;

		_pos = (d_service_buildings select 2) select 0;
		_dir = (d_service_buildings select 2) select 1;
		_fac = createVehicle [d_servicepoint_building, _pos, [], 0, "NONE"];
		_fac setDir _dir;
		_fac setPos _pos;
	};
};

if (d_with_ai) then {
	d_pos_ai_hut = [markerPos "d_pos_aihut", markerDir "d_pos_aihut"];
	d_AI_HUT = createVehicle ["Land_CashDesk_F", d_pos_ai_hut select 0, [], 0, "NONE"];
	d_AI_HUT setDir (d_pos_ai_hut select 1);
	d_AI_HUT setPos (d_pos_ai_hut select 0);
	d_AI_HUT addEventHandler ["handleDamage", {0}];
	publicVariable "d_AI_HUT";
	["d_RecruitB_100010000", d_pos_ai_hut select 0,"ICON","ColorYellow",[0.5,0.5],localize "STR_DOM_MISSIONSTRING_313",0,"mil_dot"] call d_fnc_CreateMarkerGlobal;
};
deleteMarker "d_pos_aihut";

d_le_player_boxbos = markerPos "d_player_ammobox_pos";
if (isMultiplayer) then {
	deleteMarkerLocal "d_player_ammobox_pos";
};

_civcenter = createCenter civilian;

#ifdef __OWN_SIDE_BLUFOR__
_opforcenter = createCenter opfor;
_independentcenter = createCenter independent;
blufor setFriend [opfor, 0.1];
opfor setFriend [blufor, 0.1];
blufor setFriend [independent, 1];
independent setFriend [blufor, 1];
opfor setFriend [independent, 0.1];
independent setFriend [opfor, 0.1];
#endif

#ifdef __OWN_SIDE_OPFOR__
_bluforcenter = createCenter blufor;
_independentcenter = createCenter independent;
blufor setFriend [opfor, 0.1];
opfor setFriend [blufor, 0.1];
blufor setFriend [independent, 0.1];
independent setFriend [blufor, 0.1];
opfor setFriend [independent, 1];
independent setFriend [opfor, 1];
#endif

#ifdef __OWN_SIDE_INDEPENDENT__
_bluforcenter = createCenter blufor;
_opforcenter = createCenter opfor;
blufor setFriend [opfor, 0.1];
opfor setFriend [blufor, 0.1];
independent setFriend [blufor, 0.1];
independent setFriend [opfor, 0.1];
blufor setFriend [independent, 0.1];
opfor setFriend [independent, 0.1];
#endif
