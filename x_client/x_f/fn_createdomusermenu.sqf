//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_createdomusermenu.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

_start_key = 1;
_fnc_inc_num = {
	_start_key = _start_key + 1;
	_start_key
};

_is_para = ((vehicle player) isKindOf "BIS_Steerable_Parachute") || {(vehicle player) isKindOf "ParachuteBase"};

d_DomUserMenu = [
	["Domination", false],
	[localize "STR_DOM_MISSIONSTRING_304", [call _fnc_inc_num], "", -5, [["expression", "0 call d_fnc_DomCommandingMenuExec"]], "1", "1"],
	["-", [0], "", -1, [["expression", ""]], "1", "1"]
];

if (d_player_can_call_arti > 0 && {d_areArtyVecsAvailable} && {!visibleMap} && {!_is_para}) then {
	d_DomUserMenu pushBack [localize "STR_DOM_MISSIONSTRING_153", [call _fnc_inc_num], "", -5, [["expression", "1 call d_fnc_DomCommandingMenuExec"]], "1", "1"];
};

d_DomUserMenu pushBack ["-", [0], "", -1, [["expression", ""]], "1", "1"];

if (d_player_can_call_drop > 0 && {!visibleMap} && {!_is_para}) then {
	d_DomUserMenu pushBack [localize "STR_DOM_MISSIONSTRING_230", [call _fnc_inc_num], "", -5, [["expression", "2 call d_fnc_DomCommandingMenuExec"]], "1", "1"];
};

if (d_player_is_medic && {vehicle player == player} && {(player getVariable "d_medtent") isEqualTo []}) then {
	d_DomUserMenu pushBack [localize "STR_DOM_MISSIONSTRING_305", [call _fnc_inc_num], "", -5, [["expression", "5 call d_fnc_DomCommandingMenuExec"]], "1", "1"];
};

if (d_eng_can_repfuel && {vehicle player == player} && {(player getVariable "d_farp_pos") isEqualTo []}) then {
	d_DomUserMenu pushBack [localize "STR_DOM_MISSIONSTRING_307", [call _fnc_inc_num], "", -5, [["expression", "6 call d_fnc_DomCommandingMenuExec"]], "1", "1"];
};

if ((player getVariable ["d_p_isadmin", false]) && {!visibleMap}) then {
	d_DomUserMenu pushBack ["-", [0], "", -1, [["expression", ""]], "1", "1"];
	
	d_DomUserMenu pushBack [localize "STR_DOM_MISSIONSTRING_1420", [call _fnc_inc_num], "", -5, [["expression", "7 call d_fnc_DomCommandingMenuExec"]], "1", "1"];
};

if (d_WithBackpack && {isNil "d_in_backpack"} && {vehicle player == player} && {!surfaceIsWater (getPosASL player)} && {(getPosATLVisual player) select 2 < 2}) then {
	_primw = primaryWeapon player;
	_bstr = if !((player getVariable "d_player_backpack") isEqualTo []) then {
		format [localize "STR_DOM_MISSIONSTRING_154", [(player getVariable "d_player_backpack") select 0, "CfgWeapons"] call d_fnc_GetDisplayName]
	} else {
		if (_primw != "") then {
			format [localize "STR_DOM_MISSIONSTRING_155", [_primw, "CfgWeapons"] call d_fnc_GetDisplayName]
		} else {
			""
		};
	};
	__TRACE_1("","_bstr")
	if (_bstr != "") then {
		d_DomUserMenu pushBack ["-", [0], "", -1, [["expression", ""]], "1", "1"];
		
		d_DomUserMenu pushBack [_bstr, [call _fnc_inc_num], "", -5, [["expression", "8 call d_fnc_DomCommandingMenuExec"]], "1", "1"];
	};
};

_clattached = player getVariable ["d_p_clattached", ""];
__TRACE_1("","_clattached")
if (_clattached == "") then {
	_chemar = call d_fnc_haschemlight;
	__TRACE_1("","_chemar")
	if (count _chemar > 0) then {
		d_DomUserMenu pushBack ["-", [0], "", -1, [["expression", ""]], "1", "1"];
		
		{
			_strnum = switch (_x) do {
				case "Chemlight_green": {"15"};
				case "Chemlight_red": {"16"};
				case "Chemlight_yellow": {"17"};
				case "Chemlight_blue": {"18"};
				default {""};
			};
			if (_strnum != "") then {
				d_DomUserMenu pushBack [format [localize "STR_DOM_MISSIONSTRING_1506", getText(configFile/"CfgMagazines"/_x/"displayName")], [call _fnc_inc_num], "", -5, [["expression", _strnum + " call d_fnc_DomCommandingMenuExec"]], "1", "1"];
			};
		} forEach _chemar;
	};
} else {
	if (_clattached != "") then {
		d_DomUserMenu pushBack ["-", [0], "", -1, [["expression", ""]], "1", "1"];
		
		d_DomUserMenu pushBack [localize "STR_DOM_MISSIONSTRING_1505", [call _fnc_inc_num], "", -5, [["expression", "20 call d_fnc_DomCommandingMenuExec"]], "1", "1"];
	};
};