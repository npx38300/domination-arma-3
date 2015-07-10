// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_supplydrop.sqf"
#include "x_setup.sqf"

private ["_vec", "_chute", "_is_ammo", "_drop_pos"];
_vec = [_this, 0] call BIS_fnc_param;
_chute = [_this, 1] call BIS_fnc_param;
_is_ammo = [_this, 2] call BIS_fnc_param;
_drop_pos = [_this, 3] call BIS_fnc_param;

if (!isNull _vec) then {
	waitUntil {(getPos _chute) select 2 <= 5 || {!alive _vec}};
} else {
	waitUntil {(getPos _chute) select 2 <= 5};
	_drop_pos = getPosASL _chute;
};

if (!isNull _vec) then {
	detach _chute;
	_chute disableCollisionWith _vec;
	if (alive _vec) then {
		if ((getPosATL _vec) select 2 <= -1) then {
			_pos_vec = getPosATL _vec;
			_vector = vectorUp _vec;
			_vec setPos [_pos_vec select 0, _pos_vec select 1, 0.2];
			_vec setVectorUp [_vector select 0, _vector select 1, 1];
			deleteVehicle _helper1;
		};
		_vec setDamage 0;
	};
} else {
	if (_is_ammo) then {
		_drop_pos set [2, 0];
		["d_air_box", _drop_pos] call d_fnc_NetCallEventToClients;
	};
};

sleep 5;

if (!isNull _chute) then {
	deleteVehicle _chute;
};
