// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_fillRecruit.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_control", "_pic", "_index", "_tt"];
disableSerialization;
_control = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1000;
lbClear _control;

{
	_ipic = getText (configFile/"cfgVehicles"/_x/"icon");
	__TRACE_2("","_x","_ipic")
	_pic = if (_ipic == "") then {
		"#(argb,8,8,3)color(1,1,1,0)"
	} else {
		getText(configFile/"CfgVehicleIcons"/_ipic)
	};
	__TRACE_1("","_pic")
	_index = _control lbAdd ([_x, "CfgVehicles"] call d_fnc_GetDisplayName);
	_control lbSetPicture [_index, _pic];
	_control lbSetColor [_index, [1, 1, 0, 0.8]];
} forEach d_UnitsToRecruit;

_control lbSetCurSel 0;

d_current_ai_num = 0;
d_current_ai_units = [];
{
	if (!isPlayer _x && {alive _x}) then {
		d_current_ai_num = d_current_ai_num + 1;
		d_current_ai_units pushBack _x;
	};
} forEach units group player;

((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1030) ctrlSetText format [localize "STR_DOM_MISSIONSTRING_693", d_current_ai_num, d_max_ai];

_control = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1001;
lbClear _control;
{
	_tt = typeOf _x;
	_ipic = getText (configFile/"cfgVehicles"/_tt/"icon");
	__TRACE_2("","_tt","_ipic")
	_pic = if (_ipic == "") then {
		"#(argb,8,8,3)color(1,1,1,0)"
	} else {
		getText(configFile/"CfgVehicleIcons"/_ipic)
	};
	__TRACE_1("","_pic")
	_index = _control lbAdd ([_tt, "CfgVehicles"] call d_fnc_GetDisplayName);
	_control lbSetPicture [_index, _pic];
	_control lbSetColor [_index, [1, 1, 0, 0.8]];
} forEach d_current_ai_units;

if !(d_current_ai_units isEqualTo []) then {
	_control lbSetCurSel 0;
};

if (d_current_ai_num == 0) then {
	((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1011) ctrlShow false;
	((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1012) ctrlShow false;
};
if (d_current_ai_num == d_max_ai) then {
	((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1010) ctrlShow false;
};