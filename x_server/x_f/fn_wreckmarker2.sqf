// by Xeno
#define THIS_FILE "fn_wreckmarker2.sqf"
#include "x_setup.sqf"
private ["_vehicle", "_mname", "_sav_pos", "_type_name", "_timedelete"];
if (!isServer) exitWith {};
_vehicle = _this;
sleep 5;
while {_vehicle distance d_wreck_rep > 30 && {(_vehicle call d_fnc_GetHeight) > 1} && {speed _vehicle > 1}} do {sleep 2 + random 2};
if (_vehicle distance d_wreck_rep <= 30) exitWith {};
while {speed _vehicle > 4 && {(getPosATL _vehicle) select 2 >= -20}} do {sleep 1.532 + random 1.2};
sleep 0.01;
if ((getPosATL _vehicle) select 2 < -20) then {
	_aposs = getPosATL _vehicle;
	_aposs set [2, 0];
	_vehicle setPos _aposs;
};
if ((vectorUp _vehicle) select 2 < 0) then {_vehicle setVectorUp [0,0,1]};
while {speed _vehicle > 4 && {(getPosATL _vehicle) select 2 >= -10}} do {sleep 1.532 + random 1.2};
if ((getPosATL _vehicle) select 2 < -20) then {
	_aposs = getPosATL _vehicle;
	_aposs set [2, 0];
	_vehicle setPos _aposs;
};
_mname = str _vehicle + "_" + str time;
_sav_pos = [getPosASL _vehicle select 0,getPosASL _vehicle select 1,0];
_vehicle setPos _sav_pos;
_vehicle setVelocity [0,0,0];
_type_name = [typeOf _vehicle, "CfgVehicles"] call d_fnc_GetDisplayName;
[_mname, _sav_pos,"ICON","ColorBlue",[1,1],format [localize "STR_DOM_MISSIONSTRING_517", _type_name],0,"mil_triangle"] call d_fnc_CreateMarkerGlobal;
_timedelete = if (d_WreckDeleteTime != -1) then {time + d_WreckDeleteTime} else {time + (1e+011)};
while {!isNull _vehicle && {_vehicle distance _sav_pos < 30} && {time < _timedelete}} do {sleep 3.321 + random 2.2};
deleteMarker _mname;
if (time > _timedelete && {_vehicle distance _sav_pos < 50}) then {
	deleteVehicle _vehicle;
} else {
	_vehicle spawn d_fnc_wreckmarker2;
};