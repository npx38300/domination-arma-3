// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_vrespawn2.sqf"
#include "x_setup.sqf"

//#define __Trans(tkind) getNumber(configFile/#CfgVehicles/typeOf _vec/#tkind)
//#define __TransCargo 0.15
private ["_vec", "_camo", "_i", "_disabled", "_empty", "_outb", "_fuelleft"];
if (!isServer) exitWith{};

_vec_array = [];
{
	__TRACE_1("_x","_x")
	_vec = _x select 0;
	if (!isNil "_vec" && {!isNull _vec}) then {
		_number_v = _x select 1;
		_vec_array pushBack [_vec,_number_v,getPosATL _vec,direction _vec,typeOf _vec];
		
		_vec setVariable ["d_OUT_OF_SPACE", -1];
		_vec setVariable ["d_vec", _number_v, true];
		_vec setAmmoCargo 0;
		_vec setVariable ["d_vec_islocked", (_vec call d_fnc_isVecLocked)];
		if (_number_v < 100 || {(_number_v > 999 && {_number_v < 1100})}) then {
			_vec addMPEventhandler ["MPKilled", {(_this select 0) call d_fnc_MHQFunc}];
		};
		_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
		
		/*
		if (__Trans(transportAmmo) > 0) then {
			_vec setAmmoCargo __TransCargo;
		} else {
			if (__Trans(transportRepair) > 0) then {
				_vec setRepairCargo __TransCargo;
			} else {
				if (__Trans(transportFuel) > 0) then {
					_vec setFuelCargo __TransCargo;
				};
			};
		};
		*/
	};
} forEach _this;
_this = nil;

sleep 11;

while {true} do {
	sleep 8 + random 5;
	call d_fnc_mpcheck;
	{
		_vec_a = _x;
		_vec = _vec_a select 0;
		
		_disabled = (damage _vec >= 0.9);
		
		_empty = _vec call d_fnc_GetVehicleEmpty;
		
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
			_number_v = _vec_a select 1;
			_fuelleft = _vec getVariable ["d_fuel", 1];
			if (_vec getVariable ["d_ammobox", false]) then {
				d_num_ammo_boxes = d_num_ammo_boxes - 1; publicVariable "d_num_ammo_boxes";
			};
			if (_number_v < 100 || {(_number_v > 999 && {_number_v < 1100})}) then {
				_dhqcamo = _vec getVariable ["d_MHQ_Camo", objNull];
				if (!isNull _dhqcamo) then {deleteVehicle _dhqcamo};
			};
			_isitlocked = _vec getVariable "d_vec_islocked"; // || {_vec call d_fnc_isVecLocked};
			sleep 0.1;
			deleteVehicle _vec;
			sleep 0.5;
			_vec = createVehicle [_vec_a select 4, _vec_a select 2, [], 0, "NONE"];
			_vec setDir (_vec_a select 3);
			_vec setPos (_vec_a select 2);
			_vec setFuel _fuelleft;
			
			if (_number_v < 100 || {(_number_v > 999 && {_number_v < 1100})}) then {
				_vec addMPEventhandler ["MPKilled", {(_this select 0) call d_fnc_MHQFunc}];
			};
			_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
			_vec_a set [0, _vec];
			_vec_array set [_forEachIndex, _vec_a];
			_vec setVariable ["d_OUT_OF_SPACE", -1];
			_vec setVariable ["d_vec", _number_v, true];
			_vec setAmmoCargo 0;
			_vec setVariable ["d_vec_islocked", _isitlocked];
			if (_isitlocked) then {_vec lock true};
			["d_n_v", _vec] call d_fnc_NetCallEventToClients;
			
			/*
			if (__Trans(transportAmmo) > 0) then {
				_vec setAmmoCargo __TransCargo;
			} else {
				if (__Trans(transportRepair) > 0) then {
					_vec setRepairCargo __TransCargo;
				} else {
					if (__Trans(transportFuel) > 0) then {
						_vec setFuelCargo __TransCargo;
					};
				};
			};
			*/			
		};
		sleep (8 + random 5);
	} forEach _vec_array;
};