// by Xeno
#define THIS_FILE "fn_airtaxiserver.sqf"
#include "x_setup.sqf"
#define __del \
{_vehicle deleteVehicleCrew _x} forEach _crew;\
deleteVehicle _vehicle;

private ["_vehicle", "_crew", "_player", "_sidep", "_grp", "_spos", "_veca", "_unit", "_pospl", "_helperh", "_toldp", "_endtime", "_doend"];
if (!isServer) exitWith {};

_player = _this;
_sidep = side (group _player);

_dstart_pos = call d_fnc_GetRanPointOuterAir;

_grp = [_sidep] call d_fnc_creategroup;
_spos = [_dstart_pos select 0, _dstart_pos select 1, 300];
_veca = [_spos, [_spos, getPosATL _player] call d_fnc_DirTo, d_taxi_aircraft, _grp] call d_fnc_spawnVehicle;
_vehicle = _veca select 0;
_crew = _veca select 1;
_unit = driver _vehicle;
d_allunits_add pushBack _vehicle;
_unit setSkill 1;

_vehicle lockDriver true;

_pospl = getPosASL player;
_pospl set [2,0];
_helperh = d_HeliHEmpty createVehicleLocal _pospl;
_vehicle flyInHeight 80;
_unit doMove (getPosATL _player);
_vehicle flyInHeight 80;
_grp setBehaviour "CARELESS";
["d_airtaxi_marker", getPosATL _vehicle, "ICON", (switch (_sidep) do {case opfor: {"ColorEAST"};case blufor: {"ColorWEST"};case independent: {"ColorGUER"};default {"ColorCIV"};}), [1,1], "Air Taxi", 0, (switch (_sidep) do {case blufor: {"b_air"};case opfor: {"o_air"};default {"n_air"};})] call d_fnc_CreateMarkerGlobal;

sleep 10;

if (!alive _player || isNull _player) exitWith {
	deleteMarker "d_airtaxi_marker";
	d_heli_taxi_available = true;
	publicVariable "d_heli_taxi_available";
	["d_ataxi", [_player, 1]] call d_fnc_NetCallEventSTO;
	sleep 120;
	__del;
};

["d_ataxi", [_player, 0]] call d_fnc_NetCallEventSTO;

_toldp = false;
_endtime = time + 720;
_doend = false;
while {alive _unit && {alive _vehicle} && {canMove _vehicle}} do {
	"d_airtaxi_marker" setMarkerPos (getPosASL _vehicle);
	if (!_toldp) then {
		if (_vehicle distance _helperh < 1000 && {alive _player}) then {
			["d_ataxi", [_player, 6]] call d_fnc_NetCallEventSTO;
			_toldp = true;
		};
	};
	if (unitReady _unit) exitWith {
		sleep 0.1;
		_vehicle land "LAND";
	};
	if (time > _endtime) exitWith {
		_doend = true;
	};
	sleep 2.012;
};

if (!alive _unit || {!alive _vehicle} || {!canMove _vehicle} || {_doend}) exitWith {
	deleteMarker "d_airtaxi_marker";
	d_heli_taxi_available = true;
	publicVariable "d_heli_taxi_available";
	["d_ataxi", [_player, 2]] call d_fnc_NetCallEventSTO;
	sleep 120;
	__del;
};

if (alive _unit && {alive _player} && {alive _vehicle} && {canMove _vehicle}) then {
	_endtime = time + 820;
	_doend = false;
	while {alive _unit && {alive _vehicle} && {alive _player} && {!(_player in crew _vehicle)} && {canMove _vehicle}} do {
		"d_airtaxi_marker" setMarkerPos (getPosASL _vehicle);
		if (time > _endtime) exitWith {
			_doend = true;
			deleteMarker "d_airtaxi_marker";
			d_heli_taxi_available = true;
			publicVariable "d_heli_taxi_available";
			["d_ataxi", [_player, 2]] call d_fnc_NetCallEventSTO;
			sleep 120;
			__del;
		};
		sleep 1.012;
	};
	if (_doend) exitWith {};
	if (alive _unit && {alive _vehicle} && {canMove _vehicle}) then {
		["d_ataxi", [_player, 3]] call d_fnc_NetCallEventSTO;
		
		sleep 30 + random 5;
		["d_ataxi", [_player, 5]] call d_fnc_NetCallEventSTO;
		_vehicle flyInHeight 80;
		_unit doMove (getPosATL d_AISPAWN);
		_vehicle flyInHeight 80;
		_grp setBehaviour "CARELESS";
		sleep 5;
		_doend = false;
		while {alive _unit && {alive _vehicle} && {canMove _vehicle}} do {
			"d_airtaxi_marker" setMarkerPos (getPosASL _vehicle);
			if (unitReady _unit) exitWith {
				sleep 0.1;
				_vehicle land "LAND";
			};
			if (!alive _unit || {!alive _vehicle} || {!canMove _vehicle}) exitWith {
				_doend = true;
				["d_ataxi", [_player, 2]] call d_fnc_NetCallEventSTO;
				deleteMarker "d_airtaxi_marker";
				d_heli_taxi_available = true;
				publicVariable "d_heli_taxi_available";
				sleep 120;
				__del;
			};
			sleep 2.012
		};
		if (_doend) exitWith {};
		
		while {alive _unit && {alive _vehicle} && {alive _player} && {(_player in crew _vehicle)} && {canMove _vehicle}} do {
			sleep 3.221;
		};
		sleep 20 + random 5;
		
		if (alive _unit && {alive _vehicle} && {canMove _vehicle}) then {
			["d_ataxi", [_player, 4]] call d_fnc_NetCallEventSTO;
			_vehicle flyInHeight 80;
			_unit doMove _dstart_pos;
			_vehicle flyInHeight 80;
			_grp setBehaviour "CARELESS";
			_endtime = time + 720;
			while {alive _unit && {alive _vehicle} && {canMove _vehicle}} do {
				"d_airtaxi_marker" setMarkerPos (getPosASL _vehicle);
				if (_vehicle distance _dstart_pos < 300) exitWith {};
				if (time > _endtime) exitWith {};
				sleep 2.012
			};
			deleteMarker "d_airtaxi_marker";
			d_heli_taxi_available = true;
			publicVariable "d_heli_taxi_available";
			sleep 120;
			__del;
		} else {
			["d_ataxi", [_player, 1]] call d_fnc_NetCallEventSTO;
			deleteMarker "d_airtaxi_marker";
			d_heli_taxi_available = true;
			publicVariable "d_heli_taxi_available";
			sleep 120;
			__del;
		};
	} else {
		["d_ataxi", [_player, 1]] call d_fnc_NetCallEventSTO;
		deleteMarker "d_airtaxi_marker";
		d_heli_taxi_available = true;
		publicVariable "d_heli_taxi_available";
		sleep 120;
		__del;
	};
};

deleteVehicle _helperh;