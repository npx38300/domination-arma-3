// d_init include common

setViewDistance d_InitialViewDistance;

d_last_target_idx = -1;
d_target_names = [];
for "_i" from 0 to 100000 do {
	_ar = [];
	_mname = format ["d_target_%1", _i];
	_dtar = missionNamespace getVariable _mname;
	if (isNil "_dtar") exitWith {
		d_last_target_idx = _i - 1;
	};
	
	_name = _dtar getVariable "d_cityname";
	if (!isNil "_name") then {
		_pos = getPosASL _dtar;
		_pos set [2, 0];
		_ar pushBack _pos; // position CityCenter by logic
		if (isServer) then {
			_dtar setDir 0;
		};
		_ar pushBack _name; // name village/city
		_ar pushBack (_dtar getVariable ["d_cityradius", 300]);
	} else {
		_nlocs = nearestLocations [getPosASL _dtar, ["NameCityCapital","NameCity","NameVillage"], 1000];
		if !(_nlocs isEqualTo []) then {
			_locposnl0 = locationPosition (_nlocs select 0);
			_nl = nearestLocations [_locposnl0, ["CityCenter"], 1000];
			_pos = if !(_nl isEqualTo []) then {
				locationPosition (_nl select 0)
			} else {
				_locposnl0
			};
			_pos set [2, 0];
			_ar pushBack _pos; // position CityCenter
			if (isServer) then {
				_dtar setDir 0;
				_dtar setPos _pos;
			};
			_name = text (_nlocs select 0);
			_ar pushBack _name; // name village/city
			_ar pushBack (_dtar getVariable ["d_cityradius", 300]);
			_dtar setVariable ["d_cityname", _name];
		} else {
			hint ("No city found near target location " + _mname);
		};
	};
	if (isServer) then {
		_dtar enableSimulationGlobal false;
	};
	__TRACE_1("All targets found","_ar")
	d_target_names pushBack _ar;
};

d_FLAG_BASE allowDamage false;
if (isServer) then {
	d_FLAG_BASE enableSimulationGlobal false;
};

// positions of service buildings
// first jet service, second chopper service, third wreck repair

if (markerType "d_base_jet_sb" != "") then {
	d_service_buildings = [[markerPos "d_base_jet_sb", markerDir "d_base_jet_sb"],[markerPos "d_base_chopper_sb", markerDir "d_base_chopper_sb"],[markerPos "d_base_wreck_sb", markerDir "d_base_wreck_sb"]];
} else {
	d_service_buildings = [];
};
if (isServer) then {
	deleteMarker "d_base_jet_sb";
	deleteMarker "d_base_chopper_sb";
	deleteMarker "d_base_wreck_sb";
};

// position base, a,b, for the enemy at base trigger and marker
"d_base_marker" setMarkerAlphaLocal 0;
_msize = markerSize "d_base_marker";
d_base_array = [markerPos "d_base_marker", _msize select 0, _msize select 1, markerDir "d_base_marker"];

if (isServer) then {
	d_base_trigger_d = createTrigger["EmptyDetector" ,d_base_array select 0];
	publicVariable "d_base_trigger_d";

	d_engineer_trigger_d = createTrigger["EmptyDetector" ,d_base_array select 0];
	publicVariable "d_engineer_trigger_d";
	
	d_eabase_trig1 = createTrigger["EmptyDetector" ,d_base_array select 0];
	d_eabase_trig2 = createTrigger["EmptyDetector" ,d_base_array select 0];
	publicVariable "d_eabase_trig1";
	publicVariable "d_eabase_trig2";
	
	d_player_base_trig = createTrigger["EmptyDetector" ,d_base_array select 0];
	publicVariable "d_player_base_trig";
	
	d_player_base_trig2 = createTrigger["EmptyDetector" , getPosATL d_FLAG_BASE];
	publicVariable "d_player_base_trig2";
};

if (d_with_ai || {d_with_ai_features == 0}) then {
if (isNil "d_heli_taxi_available") then {d_heli_taxi_available = true;};
d_ai_radio_trig = createTrigger ["EmptyDetector", [0, 0, 0]];
d_ai_radio_trig setTriggerText (localize "STR_DOM_MISSIONSTRING_535");
d_ai_radio_trig setTriggerActivation ["HOTEL", "PRESENT", true];
d_ai_radio_trig setTriggerStatements ["local player", "0 = 0 spawn d_fnc_airtaxi", ""];
publicVariable "d_ai_radio_trig";
};

if (isServer) then {
if (markerType "d_runwaymarker" != "") then {
d_base_runway_marker_trig = createTrigger ["EmptyDetector", markerPos "d_runwaymarker"];
publicVariable "d_base_runway_marker_trig";
};
};

// position of anti air at own base
d_base_anti_air1 = markerPos "d_base_anti_air1";
d_base_anti_air2 = markerPos "d_base_anti_air2";

"d_isledefense_marker" setMarkerAlphaLocal 0;
