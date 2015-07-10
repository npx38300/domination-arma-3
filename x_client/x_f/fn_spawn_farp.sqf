// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_spawn_farp.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_nos", "_notruck", "_vt", "_helper1", "_helper2", "_helper3", "_helper4", "_mt", "_helper", "_farp", "_exitit"];

if (player getVariable ["d_isinaction", false]) exitWith {
	d_commandingMenuIniting = false;
};

if (player distance d_FLAG_BASE < 30) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_246");
	d_commandingMenuIniting = false;
};

if ((player call d_fnc_GetHeight) > 5) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_241");
	d_commandingMenuIniting = false;
};

if !((player getVariable "d_farp_pos") isEqualTo []) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_242");
	d_commandingMenuIniting = false;
};

_nos = (getPosATL player) nearEntities ["Truck_F", 20];
_notruck = true;
if !(_nos isEqualTo []) then {
	{
		if ((_x getVariable ["d_vec_type", ""]) == "Engineer") exitWith {_notruck = false};
	} forEach _nos;
};

if (_notruck) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_243");
	d_commandingMenuIniting = false;
};

_d_farp_pos = player modelToWorldVisual [0,8,0];
_d_farp_pos set [2,0];

if (surfaceIsWater _d_farp_pos) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_244");
	d_commandingMenuIniting = false;
};

if (d_with_ranked && {score player < (d_ranked_a select 20)}) exitWith {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_245", score player, d_ranked_a select 20];
	d_commandingMenuIniting = false;
};

_helper1 = d_HeliHEmpty createVehicleLocal [_d_farp_pos select 0, (_d_farp_pos select 1) + 4, 0];
_helper2 = d_HeliHEmpty createVehicleLocal [_d_farp_pos select 0, (_d_farp_pos select 1) - 4, 0];
_helper3 = d_HeliHEmpty createVehicleLocal [(_d_farp_pos select 0) + 4, _d_farp_pos select 1, 0];
_helper4 = d_HeliHEmpty createVehicleLocal [(_d_farp_pos select 0) - 4, _d_farp_pos select 1, 0];

_exit_it = false;
if ((abs (((getPosASL _helper1) select 2) - ((getPosASL _helper2) select 2)) > 2) || {(abs (((getPosASL _helper3) select 2) - ((getPosASL _helper4) select 2)) > 2)}) then {
	systemChat (localize "STR_DOM_MISSIONSTRING_246");
	_exit_it = true;
};

{
	deleteVehicle _x;
} forEach [_helper1, _helper2, _helper3, _helper4];

if (_exit_it) exitWith {
	d_commandingMenuIniting = false;
};

player setVariable ["d_isinaction", true];

if (d_with_ranked) then {["d_pas", [player, (d_ranked_a select 20) * -1]] call d_fnc_NetCallEventCTS};

player playMove "AinvPknlMstpSlayWrflDnon_medic";
sleep 1;
waitUntil {animationState player != "AinvPknlMstpSlayWrflDnon_medic" || {!alive player} || {player getVariable ["xr_pluncon", false]}};
d_commandingMenuIniting = false;
if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_247");
	player setVariable ["d_isinaction", false];
};

_dir_to_set = getDirVisual player;

_farptype = d_farp_classes select 0;

_mapSize = getNumber(configFile/"CfgVehicles"/_farptype/"mapSize");

_farp = createVehicle [_farptype, _d_farp_pos, [], 0, "NONE"];
_farp setDir _dir_to_set;
_farp setPos _d_farp_pos;
[_farp, 0] call d_fnc_SetHeight;

_farptrig = [
getPosATL _farp,
[_mapSize, _mapSize, getDirVisual _farp, true],
["ANY", "PRESENT", true],
["(thislist call d_fnc_tchopservice) || {(thislist call d_fnc_tvecservice)} || {(thislist call d_fnc_tjetservice)}", "0 = [thislist] spawn d_fnc_reload", ""]
] call d_fnc_CreateTrigger;

_farpcont = [_farptrig];

_mapSize = _mapSize + 10;
_farp_o_pos = [_d_farp_pos, _mapSize] call d_fnc_getranpointcircleouter;
_farp_seco = createVehicle [d_farp_classes select 1, _farp_o_pos, [], 0, "NONE"];
_farp_seco setDir (random 360);
_farp_seco setPos _farp_o_pos;

_farpcont pushBack _farp_seco;

if (count d_farp_classes > 2) then {
	for "_i" from 2 to (count d_farp_classes - 1) do {
		_farp_o_pos = [_d_farp_pos, _mapSize] call d_fnc_getranpointcircleouter;
		_farp_o = createVehicle [d_farp_classes select _i, _farp_o_pos, [], 0, "NONE"];
		_farp_o setDir (random 360);
		_farp_o setPos _farp_o_pos;
		
		_farpcont pushBack _farp_o;
	};
};

_farp setVariable ["d_objcont", _farpcont, true];

_d_farp_pos = getPosATL _farp;
player setVariable ["d_farp_pos", _d_farp_pos];

player setVariable ["d_farp_obj", _farp];

d_farps pushBack _farp;
publicVariable "d_farps";

systemChat (localize "STR_DOM_MISSIONSTRING_248");
["d_p_o_a", [d_string_player, [_farp, "FARP " + d_string_player, d_name_pl, player]]] call d_fnc_NetCallEventCTS;
["d_farp_e", [_farp, player]] call d_fnc_NetCallEventToClients;

_farp_seco addAction [(localize "STR_DOM_MISSIONSTRING_249") call d_fnc_RedText, {
	_this call {
		private "_farp";
		_farp = player getVariable ["d_farp_obj", objNull];
		if (isNull _farp) exitWith {};

		player playMove "AinvPknlMstpSlayWrflDnon_medic";
		sleep 1;
		waitUntil {animationState player != "AinvPknlMstpSlayWrflDnon_medic" || {!alive player} || {player getVariable ["xr_pluncon", false]}};
		if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_315")};
		
		d_farps = d_farps - [_farp];
		publicVariable "d_farps";

		_farpcont = _farp getVariable ["d_objcont", []];
		if !(_farpcont isEqualTo []) then {
			{
				deleteVehicle _x;
			} forEach _farpcont;
		};
		deleteVehicle _farp;
		
		player setVariable ["d_farp_obj", objNull];

		systemChat (localize "STR_DOM_MISSIONSTRING_316");
		player setVariable ["d_farp_pos", []];
		["d_p_o_r", [d_string_player,"FARP " + d_string_player]] call d_fnc_NetCallEventCTS;
	};
}];

player setVariable ["d_isinaction", false];
