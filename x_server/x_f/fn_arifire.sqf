// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_arifire.sqf"
#include "x_setup.sqf"
private ["_radius", "_series", "_angle", "_i", "_nos", "_aristr", "_ari_vecs", "_ari_target_pos", "_sel_ari_marker"];
if (!isServer) exitWith {};

_ari_type = [_this, 0] call BIS_fnc_param;
_ari_salvos = [_this, 1] call BIS_fnc_param;
_arti_operator = [_this, 2] call BIS_fnc_param;
_sel_ari_marker = [_this, 3] call BIS_fnc_param;

_ari_target_pos = markerPos _sel_ari_marker;

__TRACE_3("","_ari_type","_ari_salvos","_arti_operator")
__TRACE_2("","_sel_ari_marker","_ari_target_pos")

if !(d_ari_available) exitWith {};

d_ari_available = false; publicVariable "d_ari_available";
["d_upd_sup"] call d_fnc_NetCallEventToClients;

sleep 9.123;

d_kb_logic1 kbTell [_arti_operator,d_kb_topic_side_arti,"ArtilleryRoger",["1","",localize "STR_DOM_MISSIONSTRING_934",[]],"SIDE"];
sleep 1;
_aristr = localize "STR_DOM_MISSIONSTRING_937";
d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "ArtilleryUnAvailable", ["1", "", _aristr, []],"GLOBAL"];

sleep 6.54;
d_kb_logic1 kbTell [_arti_operator,d_kb_topic_side_arti,"ArtilleryExecute",["1","",_aristr,[]],["2","",getText(configFile/"CfgMagazines"/_ari_type/"displayname"),[]],["3","",str _ari_salvos,[]],"SIDE"];

sleep 8 + (random 7);

_ari_vecs = [];
for "_i" from 0 to 30 do {
	_vvx = missionNamespace getVariable format ["d_artyvec_%1", _i];
	if (!isNil "_vvx") then {
		_ari_vecs pushBack _vvx;
	};
};

__TRACE_1("","_ari_vecs")

if (_ari_vecs isEqualTo []) exitWith {
	d_ari_available = true; publicVariable "d_ari_available";
	["d_upd_sup"] call d_fnc_NetCallEventToClients;
	["d_a_is_w", _arti_operator] call d_fnc_NetCallEventSTO;
};

_eta_time = (_ari_vecs select 0) getArtilleryETA [_ari_target_pos, _ari_type];
__TRACE_1("","_eta_time")

//_inrange = _ari_target_pos inRangeOfArtillery [[(_ari_vecs select 0)], _ari_type];
//__TRACE_2("","_eta_time","_inrange")

_ammoconf = configFile/"CfgAmmo"/getText(configFile/"CfgMagazines"/_ari_type/"ammo");
_is_flare = getText(_ammoconf/"effectFlare") == "CounterMeasureFlare";
_is_smoke = getText(_ammoconf/"submunitionAmmo") == "SmokeShellArty";

__TRACE_3("","_ammoconf","_is_flare","_is_smoke")

if (getText(_ammoconf/"submunitionAmmo") == "Mo_cluster_AP") then {
	_ari_vecs resize 1;
	__TRACE("is cluster")
};

_enemy_units = [];
_soldier_type = switch (d_enemy_side) do {
	case "OPFOR": {"SoldierEB"};
	case "BLUFOR": {"SoldierWB"};
	case "INDEPENDENT": {"SoldierGB"};
};

_aweapon = getArray(configFile/"CfgVehicles"/(typeOf (_ari_vecs select 0))/"Turrets"/"MainTurret"/"weapons") select 0;
_reloadtime = getNumber(configFile/"CfgWeapons"/_aweapon/"reloadTime");

for "_series" from 1 to _ari_salvos do {
	{	
		_x setVehicleAmmo 1;
		_x setFuel 1;
		_x setDamage 0;
		
		_radius = 20 + random 10;
		_angle = floor random 360;
		
		_x doArtilleryFire [[(_ari_target_pos select 0) - ((random _radius) * sin _angle), (_ari_target_pos select 1) - ((random _radius) * cos _angle), 0], _ari_type, 1];
		sleep 0.2;
	} forEach _ari_vecs;
	
	d_kb_logic1 kbTell [_arti_operator,d_kb_topic_side_arti,"ArtilleryOTW",["1","",str _series,[]],["2","",str(round _eta_time),[]],"SIDE"];

	sleep _eta_time;
	
	d_kb_logic1 kbTell [_arti_operator,d_kb_topic_side_arti,"ArtillerySplash",["1","",str _series,[]],"SIDE"];

	if (!_is_flare && {!_is_smoke}) then {
		_nos = _ari_target_pos nearEntities [_soldier_type, 40];
		{if !(_x in _enemy_units) then {_enemy_units pushBack _x}} forEach _nos;
	};

	if (_series < _ari_salvos) then {
		d_kb_logic1 kbTell [_arti_operator,d_kb_topic_side_arti,"ArtilleryReload",["1","",_aristr,[]],"SIDE"];
		sleep _reloadtime;
	};
};

sleep 3;

_arti_operator addScore ({!alive _x} count _enemy_units);
_enemy_units = nil;
sleep 0.5;

d_kb_logic1 kbTell [_arti_operator,d_kb_topic_side_arti,"ArtilleryComplete",["1","",_aristr,[]],"SIDE"];

if (markerType _sel_ari_marker != "" && {_ari_target_pos isEqualTo (markerPos _sel_ari_marker)}) then {
	deleteMarker _sel_ari_marker;
};

[_ari_salvos, _aristr] spawn {
	scriptName "spawn_x_arifire_artiavailable";
	private ["_ari_salvos", "_aristr"];
	_ari_salvos = [_this, 0] call BIS_fnc_param;
	_aristr = [_this, 1] call BIS_fnc_param;
	sleep (300 + ((_ari_salvos - 1) * 200)) + (random 60) + (if (d_MissionType != 2) then {0} else {300});
	d_ari_available = true; publicVariable "d_ari_available";
	["d_upd_sup"] call d_fnc_NetCallEventToClients;
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "ArtilleryAvailable", ["1", "", _aristr, []],"GLOBAL"];
};
