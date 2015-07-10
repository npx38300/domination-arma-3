// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_unload_static.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vec","_cargo","_ele","_static","_tr_cargo_ar","_place_error","_pos_to_set","_dir_to_set","_type_name"];

_vec = [_this, 0] call BIS_fnc_param;
_cargo = "";

d_cargo_selected_index = -1;

if (!d_with_ai && {d_with_ai_features != 0} && {!(d_string_player in d_is_engineer)}) exitWith {hintSilent (localize "STR_DOM_MISSIONSTRING_79")};

_tr_cargo_ar = _vec getVariable ["d_CARGO_AR", []];

if (_tr_cargo_ar isEqualTo []) exitWith {};
	
d_current_truck_cargo_array = _tr_cargo_ar;
createDialog "d_UnloadDialog";

waitUntil {d_cargo_selected_index != -1 || {!d_unload_dialog_open} || {!alive player} || {player getVariable ["xr_pluncon", false]}};

if (!alive player || {player getVariable ["xr_pluncon", false]}) exitWith {if (d_unload_dialog_open) then {closeDialog 0}};

if (d_cargo_selected_index == -1) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_82")};

if ((d_cargo_selected_index + 1) > count _tr_cargo_ar) exitWith {
	hintSilent (localize "STR_DOM_MISSIONSTRING_83");
};

_cargo = _tr_cargo_ar select d_cargo_selected_index;
{
	if (_x == _cargo) exitWith {_tr_cargo_ar set [_forEachIndex, -1]};
} forEach _tr_cargo_ar;

_tr_cargo_ar = _tr_cargo_ar - [-1];
_vec setVariable ["d_CARGO_AR", _tr_cargo_ar, true];

_pos_to_set = player modelToWorldVisual [0,5,0];
_static = _cargo createVehicleLocal _pos_to_set;
_static lock false;
_dir_to_set = getDir player;

_place_error = false;
systemChat (localize "STR_DOM_MISSIONSTRING_84");
d_e_placing_running = 0; // 0 = running, 1 = placed, 2 = placing canceled
d_e_placing_id1 = player addAction [(localize "STR_DOM_MISSIONSTRING_85") call d_fnc_RedText, {
	private ["_caller"];
	_caller = _this select 1;
	d_e_placing_running = 2;
	_caller removeAction (_this select 2);
	_caller removeAction d_e_placing_id2;
	d_e_placing_id1 = -1000;
	d_e_placing_id2 = -1000;
}];
d_e_placing_id2 = player addAction [(localize "STR_DOM_MISSIONSTRING_86") call d_fnc_GreyText, {
	private ["_caller","_id"];
	_caller = _this select 1;
	_id = _this select 2;
	d_e_placing_running = 1;
	_caller removeAction _id;
	_caller removeAction d_e_placing_id1;
	d_e_placing_id1 = -1000;
	d_e_placing_id2 = -1000;
},[], 0];
while {d_e_placing_running == 0} do {
	_pos_to_set = player modelToWorldVisual [0,5,0];
	_dir_to_set = getDir player;

	_static setDir _dir_to_set;
	_static setPos [_pos_to_set select 0, _pos_to_set select 1, 0];
	sleep 0.211;
	if (_vec distance player > 20) exitWith {
		systemChat (localize "STR_DOM_MISSIONSTRING_87");
		_place_error = true;
	};
	if (!alive player || {!alive _vec} || {player getVariable ["xr_pluncon", false]}) exitWith {
		_place_error = true;
		if (d_e_placing_id1 != -1000) then {
			player removeAction d_e_placing_id1;
			d_e_placing_id1 = -1000;
		};
		if (d_e_placing_id2 != -1000) then {
			player removeAction d_e_placing_id2;
			d_e_placing_id2 = -1000;
		};
	};
};

deleteVehicle _static;

if (_place_error) exitWith {
	_tr_cargo_ar pushBack _cargo;
	_vec setVariable ["d_CARGO_AR", _tr_cargo_ar, true];
};

if (d_e_placing_running == 2) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_88");
	_tr_cargo_ar pushBack _cargo;
	_vec setVariable ["d_CARGO_AR", _tr_cargo_ar, true];
};

_type_name = [_cargo, "CfgVehicles"] call d_fnc_GetDisplayName;

_static = createVehicle [_cargo, _pos_to_set, [], 0, "NONE"];
_static setDir _dir_to_set;
_static setPos [_pos_to_set select 0, _pos_to_set select 1, 0];
player reveal _static;
_static lock false;
["d_ad", _static] call d_fnc_NetCallEventCTS;

_str_placed = format [localize "STR_DOM_MISSIONSTRING_89", _type_name];
hintSilent _str_placed;
systemChat _str_placed;
