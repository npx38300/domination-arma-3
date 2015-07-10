// by Xeno
#define THIS_FILE "fn_bike.sqf"
#include "x_setup.sqf"
private ["_create_bike", "_disp_name", "_pos", "_vehicle", "_exitit", "_dosearch", "_index", "_parray", "_rank"];
if (isDedicated) exitWith {};

_create_bike = (_this select 3) select 0;
_b_mode = (_this select 3) select 1;

_exitit = false;
if (d_with_ranked) then {
	_dosearch = true;
	if (count d_create_bike > 1) then {
		_index = d_create_bike find _create_bike;
		if (_index != -1) then {
			_dosearch = false;
			_parray = [d_points_needed select 1, d_points_needed select 2, d_points_needed select 3, d_points_needed select 4, d_points_needed select 5, d_points_needed select 5];
			if (_index < count _parray && {score player < (_parray select _index)}) then {
				_rank = switch (_parray select _index) do {
					case (d_points_needed select 1): {"Sergeant"};
					case (d_points_needed select 2): {"Lieutenant"};
					case (d_points_needed select 3): {"Captain"};
					case (d_points_needed select 4): {"Major"};
					case (d_points_needed select 5): {"Colonel"};
				};
				systemChat format [localize "STR_DOM_MISSIONSTRING_156", _rank,_create_bike];
				_exitit = true;
			};
		};
	};
	if (_dosearch && {score player < (d_ranked_a select 6)}) then {
		_rank = (d_ranked_a select 6) call d_fnc_GetRankFromScore; 
		_exitit = true;
		systemChat format[localize "STR_DOM_MISSIONSTRING_156", _rank, _create_bike];
	};
};
if (_exitit) exitWith {};

_disp_name = [_create_bike, "CfgVehicles"] call d_fnc_GetDisplayName;

if (vehicle player != player) exitWith {
	systemChat format [localize "STR_DOM_MISSIONSTRING_158", _disp_name];
};

if (isNil {player getVariable "d_bike_created"}) then {player setVariable ["d_bike_created", false]};
if (_b_mode == 1 && {player getVariable "d_bike_created"}) exitWith {systemChat (localize "STR_DOM_MISSIONSTRING_159")};

if (diag_tickTime > d_vec_end_time && {!isNull d_flag_vec} && {(d_flag_vec call d_fnc_GetVehicleEmpty)}) then {
	deleteVehicle d_flag_vec;
	d_flag_vec = objNull;
	d_vec_end_time = -1;
};
if (_b_mode == 0 && {alive d_flag_vec}) exitWith {
	systemChat format [localize "STR_DOM_MISSIONSTRING_160",0 max (round((d_vec_end_time - diag_tickTime)/60))];
};

if (d_with_ranked) then {
	["d_pas", [player, (d_ranked_a select 5) * -1]] call d_fnc_NetCallEventCTS;
};

systemChat format [localize "STR_DOM_MISSIONSTRING_161", _disp_name];
sleep 3.123;
player setVariable ["d_bike_b_mode", _b_mode];
_vet = if (_b_mode == 1) then {-1} else {
	d_vec_end_time = diag_tickTime + 600;
	d_vec_end_time
};
["d_crbike", [player, _create_bike, _b_mode, _vet]] call d_fnc_NetCallEventCTS;
player setVariable ["d_bike_created", true];

