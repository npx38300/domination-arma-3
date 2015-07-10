// by Xeno
#define THIS_FILE "x_setupserver.sqf"
#include "x_setup.sqf"
if (!isServer) exitWith {};

_confmapsize = getNumber(configFile/"CfgWorlds"/worldName/"mapSize");
d_island_center = [_confmapsize / 2, _confmapsize / 2, 300];

d_island_x_max = _confmapsize;
d_island_y_max = _confmapsize;

d_last_bonus_vec = "";

["itemAdd", ["DOM_SM_RES_ID", {call d_fnc_SideMissionResolved}, 1, "seconds", {d_sm_resolved && {d_cur_sm_idx != -1}}]] call bis_fnc_loop;

if (d_with_ai) then {execVM "x_server\x_delaiserv.sqf"};

if (d_MissionType in [0,2]) then {
	0 spawn {
		scriptName "spawn_x_serversetup_startsm";
		private ["_waittime","_num_p"];
		sleep 20;
		if (d_MissionType != 2) then {
			_waittime = 200 + random 10;
			_num_p = call d_fnc_PlayersNumber;
			if (_num_p > 0) then {
				{
					if (_num_p <= (_x select 0)) exitWith {
						_waittime = (_x select 1) + random 10;
					}
				} forEach d_time_until_next_sidemission;
			};
			sleep _waittime;
		} else {
			sleep 15;
		};
		0 spawn d_fnc_getsidemission;
	};
};

d_air_bonus_vecs = 0;
d_land_bonus_vecs = 0;

{
	if (getText(configFile/"CfgVehicles"/_x/"vehicleClass") == "Air") then {
		d_air_bonus_vecs = d_air_bonus_vecs + 1;
	} else {
		d_land_bonus_vecs = d_land_bonus_vecs + 1;
	};
} foreach d_sm_bonus_vehicle_array;
__TRACE_2("","d_air_bonus_vecs","d_land_bonus_vecs")

[d_base_array select 0, [d_base_array select 1, d_base_array select 2, d_base_array select 3, true], [d_enemy_side_trigger, "PRESENT", true], ["'Man' countType thislist > 0 || {'Tank' countType thislist > 0} || {'Car' countType thislist > 0}", "d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,'BaseUnderAtack','SIDE']", ""]] call d_fnc_CreateTrigger;

if (d_MissionType == 2) then {
	["itemAdd", ["DOM_MT_2_ID", {
		0 spawn {
			sleep 10;
			d_the_end = true; publicVariable "d_the_end";
			0 spawn d_fnc_DomEnd;
		};
	}, 9, "seconds", {d_all_sm_res}]] call bis_fnc_loop;
};

0 spawn {
	scriptName "spawn_x_serversetup_clean_weaponholder";
	private ["_ct", "_allmisobjs"];
	// TODO How to improve this? Means how to improve cleanup?
	while {true} do {	
		sleep (300 + random 30);
		_allmisobjs = allMissionObjects "groundWeaponHolder";
		sleep 1;
		_helperx = allMissionObjects "WeaponHolder";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		sleep 1;
		_helperx = allMissionObjects "WeaponHolderSimulated";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		sleep 1;
		_helperx = allMissionObjects "WeaponHolder_Single_F";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		sleep 1;
		_helperx = allMissionObjects "Chemlight_green";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		sleep 1;
		_helperx = allMissionObjects "Chemlight_red";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		sleep 1;
		_helperx = allMissionObjects "Chemlight_yellow";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		sleep 1;
		_helperx = allMissionObjects "Chemlight_blue";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		sleep 1;
		_helperx = allMissionObjects "CraterLong";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		_helperx = allMissionObjects "CraterLong_small";
		if !(_helperx isEqualTo []) then {
			_allmisobjs = [_allmisobjs, _helperx] call d_fnc_arraypushstack;
		};
		if !(_allmisobjs isEqualTo []) then {
			{
				if (!isNull _x) then {
					_ct = _x getVariable ["d_checktime", -1];
					if (_ct == -1) then {
						_x setVariable ["d_checktime", time];
					} else {
						if (({isPlayer _x} count ((ASLtoATL (getPosASL _x)) nearEntities ["CAManBase", 70])) == 0) then {
							deleteVehicle _x;
						};
					};
				};
				sleep 0.212;
			} forEach _allmisobjs;
		};
		_allmisobjs = nil;
	};
};

if (isSteamMission) exitWith {endMission "LOSER"};

for "_i" from 1 to 30 do {
	_av = missionNamespace getVariable format ["d_artyvec_%1", _i];
	if (isNil "_av") exitWith {};
	_av addEventHandler ["handleDamage", {_this call d_fnc_pshootatarti;0}];
	
	if (!isNull (driver _av)) then {
		_av spawn {
			private "_driver";
			_driver = driver _this;
			moveOut _driver;
			waitUntil {vehicle _driver == _driver};
			_this lockDriver true;
			deleteVehicle _driver;
			_this lock 2;
		};
	};
	
	{_x addEventHandler ["handleDamage", {0}]} forEach (crew _av);
};

0 spawn {
	while {true} do {
		["d_dfps", diag_fps] call d_fnc_NetCallEventToClients;
		sleep 2;
	};
};

0 spawn d_fnc_disdeadvec;
