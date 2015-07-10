// by Xeno
#define THIS_FILE "x_vrespawnn.sqf"
#include "x_setup.sqf"
private ["_vehicles", "_var", "_vec", "_empty", "_disabled", "_lastt", "_fuelleft"];
if (!isServer) exitWith{};

_vehicles = [];

{
	_vehicles pushBack [_x, typeOf _x, getPosATL _x, direction _x];
	_x setVariable ["d_lastusedrr", time];
	_x setVariable ["d_vec_islocked", (_x call d_fnc_isVecLocked)];
	_x addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
} forEach _this;

_this = nil;

while {true} do {
	sleep 10;
	
	{
		_var = _x;
		_vec = _var select 0;
		
		_empty = _vec call d_fnc_GetVehicleEmpty;
		
		if (_empty) then {
			_disabled = (damage _vec > 0.9);
			
			if (!_disabled) then {
				_lastt = _vec getVariable "d_lastusedrr";
				if (time - _lastt > 600) then {_disabled = true};
			};
			
			if (_disabled || {!alive _vec}) then {
				_isitlocked = _vec getVariable "d_vec_islocked";
				_fuelleft = _vec getVariable ["d_fuel", 1];
				deleteVehicle _vec;
				sleep 0.5;
				_vec = createVehicle [_var select 1, _var select 2, [], 0, "NONE"];
				_vec setDir (_var select 3);
				_vec setPos (_var select 2);
				_var set [0, _vec];
				_vec setVariable ["d_vec_islocked", _isitlocked];
				if (_isitlocked) then {_vec lock true};
				_vec setFuel _fuelleft;			
				_vec addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
			};
		} else {
			_vec setVariable ["d_lastusedrr", time];
		};
		
		sleep 2;
	} forEach _vehicles;
};
