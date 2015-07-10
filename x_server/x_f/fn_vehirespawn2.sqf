// by Xeno
#define THIS_FILE "fn_vehirespawn2.sqf"
#include "x_setup.sqf"
private ["_delay","_startdir","_startpos","_type","_vehicle","_fuelleft","_isitlocked"];
if (!isServer) exitWith{};

_vehicle = [_this, 0] call BIS_fnc_param;
_delay = [_this, 1] call BIS_fnc_param;
_startpos = getPosATL _vehicle;
_startdir = getDir _vehicle;
_type = typeOf _vehicle;

_vehicle setVariable ["d_vec_islocked", (_vehicle call d_fnc_isVecLocked)];

_vehicle addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];

while {true} do {
	sleep (_delay + random 15);

	if ((_vehicle call d_fnc_GetVehicleEmpty) && {damage _vehicle > 0.9 || {!alive _vehicle}}) then {
		_isitlocked = _vehicle getVariable "d_vec_islocked";
		_fuelleft = _vehicle getVariable ["d_fuel", 1];
		deleteVehicle _vehicle;
		sleep 0.5;
		_vehicle = createVehicle [_type, _startpos, [], 0, "NONE"];
		_vehicle setdir _startdir;
		_vehicle setpos _startpos;
		_vehicle setVariable ["d_vec_islocked", _isitlocked];
		if (_isitlocked) then {_vehicle lock true};
		_vehicle setFuel _fuelleft;
		_vehicle addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_fuelCheck}}];
	};
};
