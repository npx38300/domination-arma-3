//#define __DEBUG__
// by Xeno
#define THIS_FILE "x_revive\xr_f\fn_addactions.sqf"
#include "xr_macros.sqf"

if (isDedicated) exitWith {};

private ["_unit"];
_unit = _this;
if (_unit getVariable ["xr_ReviveAction", -9999] == -9999) then {
	_reviveorcprs = if (xr_pl_can_revive) then {localize "STR_DOM_MISSIONSTRING_923"} else {localize "STR_DOM_MISSIONSTRING_924"};
	_unit setVariable ["xr_ReviveAction", _unit addAction ["<t color='#FF0000'>" + _reviveorcprs + " " + name _unit + "</t>", {_this call xr_fnc_cdorevive}, [], -1, false, false, "", "(_this distance _target <= 3) && {(_target getVariable 'xr_pluncon')} && {!(_this getVariable 'xr_pisinaction')} && {time > (_target getVariable 'xr_busyt')} && {!(_target getVariable 'xr_dragged')}"]];
	_unit setVariable ["xr_DragAction", _unit addAction [format ["<t color='#FF0000'>Drag %1</t>", name _unit], {player setVariable ["xr_cursorTarget", _this select 0]; 0 spawn xr_fnc_drag}, [], -1, false, false, "", "(_this distance _target <= 3) && {(_target getVariable 'xr_pluncon')} && {!(_this getVariable 'xr_pisinaction')} && {time > (_target getVariable 'xr_busyt')} && {!(_target getVariable 'xr_dragged')}"]];
};