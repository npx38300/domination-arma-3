// by Xeno
#define THIS_FILE "x_helirespawn2.sqf"
#include "x_setup.sqf"
private ["_heli_array", "_vec_a", "_vec", "_number_v", "_is_blufor_chopper", "_i", "_tt", "_ifdamage", "_empty", "_disabled", "_empty_respawn", "_startpos", "_hasbox", "_fuelleft"];
if (!isServer) exitWith{};

_heli_array = [];
{
	_vec_a = _x;
	_vec = _vec_a select 0;
	if (!isNil "_vec" && {!isNull _vec}) then {
		_number_v = _vec_a select 1;
		_ifdamage = _vec_a select 2;
		_vposp = getPosATL _vec;
		_vposp set [2, (_vposp select 2) + 0.1];
		_heli_array pushBack [_vec, _number_v, _ifdamage, -1, _vposp, direction _vec, typeOf _vec, if (_ifdamage) then {-1} else {_vec_a select 3}];
		
		_vec setVariable ["d_OUT_OF_SPACE", -1];
		_vec setVariable ["d_vec", _number_v, true];
		_vec setVariable ["d_vec_islocked", (_vec call d_fnc_isVecLocked)];
		
		_vec setPos _vposp;
		_vec setDamage 0;
		
		_vec addEventhandler ["local", {_this call d_fnc_heli_local_check}];
		
		_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_chopperkilled}}];
	};
} forEach _this;
_this = nil;

sleep 10;

_isfirst = true;

while {true} do {
	call d_fnc_mpcheck;
	{
		_tt = 20 + random 10;
		sleep _tt;
		_vec_a = _x;
		_vec = _vec_a select 0;
		_ifdamage = _vec_a select 2;
		
		_empty = _vec call d_fnc_GetVehicleEmpty;
		
		_disabled = false;
		if (!_ifdamage) then {
			if (_empty) then {
				_empty_respawn = _vec_a select 3;
				if (_empty_respawn == -1) then {
					if (_vec distance (_vec_a select 4) > 10) then {
						_vec_a set [3, time + (_vec_a select 7)];
					};
				} else {
					if (time > _empty_respawn && {{_x distance _vec < 100} count (if (isMultiplayer) then {playableUnits} else {switchableUnits}) == 0}) then {
						_disabled = true;
					};
				};
			} else {
				if (alive _vec) then {_vec_a set [3,-1]};
			};
		};
			
		if (!_disabled && {damage _vec >= 0.9}) then {_disabled = true};
		
		if (_empty && {!_disabled} && {alive _vec} && {(_vec call d_fnc_OutOfBounds)}) then {
			_outb = _vec getVariable "d_OUT_OF_SPACE";
			if (_outb != -1) then {
				if (time > _outb) then {_disabled = true};
			} else {
				_vec setVariable ["d_OUT_OF_SPACE", time + 600];
			};
		} else {
			_vec setVariable ["d_OUT_OF_SPACE", -1];
		};
		
		sleep 0.01;
		
		if (_empty && {_disabled || {!alive _vec}}) then {
			_fuelleft = _vec getVariable ["d_fuel", 1];
			if (_vec getVariable ["d_ammobox", false]) then {
				d_num_ammo_boxes = d_num_ammo_boxes - 1; publicVariable "d_num_ammo_boxes";
			};
			_isitlocked = _vec getVariable "d_vec_islocked" || {_vec call d_fnc_isVecLocked};
			sleep 0.1;
			deleteVehicle _vec;
			if (!_ifdamage) then {_vec_a set [3,-1]};
			sleep 0.5;
			_vec = createVehicle [_vec_a select 6, _vec_a select 4, [], 0, "NONE"];
			_vec setDir (_vec_a select 5);
			_vec setPos (_vec_a select 4);			
			_vec setVariable ["d_vec_islocked", _isitlocked];
			if (_isitlocked) then {_vec lock true};
			
			_vec setFuel _fuelleft;
			_vec setDamage 0;
			
			_vec addEventhandler ["local", {_this call d_fnc_heli_local_check}];
			
			_vec_a set [0, _vec];
			_heli_array set [_forEachIndex, _vec_a];
			_vec setVariable ["d_OUT_OF_SPACE", -1];
			_vec setVariable ["d_vec", _vec_a select 1, true];
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_chopperkilled}}];
			["d_n_v", _vec] call d_fnc_NetCallEventToClients;
		};
	} forEach _heli_array;
	sleep 20 + random 5;
};