//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_vec_welcome_message.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vec","_vtype"];
_vec = [_this, 0] call BIS_fnc_param;
_vtype = [_this, 1] call BIS_fnc_param;
_welcome_str = format [localize "STR_DOM_MISSIONSTRING_627", d_name_pl];
_vec_msg1 = if (_vtype == "MHQ") then {
	localize "STR_DOM_MISSIONSTRING_628"
} else {
	if (_vtype == "Engineer") then {
		localize "STR_DOM_MISSIONSTRING_629"
	} else {
		""
	};
};
_struct_text = composeText[parseText("<t color='#f0a7ff31' size='1'>" + _welcome_str + "</t>"), lineBreak,lineBreak,_vec_msg1];
_endtime = time + 8;
hintSilent _struct_text;
while {vehicle player != player && {alive player} && {time < _endtime} && {!(player getVariable ["xr_pluncon", false])}} do {
	sleep 1;
	hintSilent _struct_text;
};
hintSilent "";