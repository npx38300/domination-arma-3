// by Xeno
#define THIS_FILE "fn_newflagclient.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_flag"];
_flag = _this;

player reveal _flag;

if (d_jumpflag_vec == "") then {
	_flag setVariable ["d_jf_id", _flag addAction [(localize "STR_DOM_MISSIONSTRING_296") call d_fnc_BlueText, {_this spawn d_fnc_paraj}]];
} else {
	_flag setVariable ["d_jf_id", _flag addAction [(format [localize "STR_DOM_MISSIONSTRING_297", [d_jumpflag_vec, "CfgVehicles"] call d_fnc_GetDisplayName]) call d_fnc_BlueText,{_this spawn d_fnc_bike},[d_jumpflag_vec,1]]];
};
