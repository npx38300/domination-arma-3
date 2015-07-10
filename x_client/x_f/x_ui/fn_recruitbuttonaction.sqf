//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_recruitbuttonaction.sqf"
#include "x_setup.sqf"

if (isDedicated || {player getVariable "d_recdbusy"}) exitWith {};
player setVariable ["d_recdbusy", true];
private ["_exitj", "_rank", "_control", "_idx", "_torecruit", "_grp", "_unit", "_ctrl", "_pic", "_index", "_control2"];
if (d_current_ai_num >= d_max_ai) exitWith {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_694", d_max_ai];
	player setVariable ["d_recdbusy", false];
};
d_current_ai_num = d_current_ai_num + 1;
__TRACE_1("","d_current_ai_num")

if (player != leader (group player)) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_695");
	player setVariable ["d_recdbusy", false];
};

_exitj = false;
if (d_with_ranked) then {
	_rank = rank player;
	if (_rank == "PRIVATE") exitWith {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_696");
		_exitj = true;
	};

	if (score player < ((d_points_needed select 0) + (d_ranked_a select 3))) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_697", score player, d_ranked_a select 3];
		_exitj = true;
	};

	_max_rank_ai = switch (_rank) do {
		case "CORPORAL": {3};
		case "SERGEANT": {4};
		case "LIEUTENANT": {5};
		case "CAPTAIN": {6};
		case "MAJOR": {7};
		case "COLONEL": {8};
	};
	if (d_current_ai_num >= _max_rank_ai) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_698", _max_rank_ai];
		_exitj = true;
	};
	// each AI soldier costs score points
	["d_pas", [player, (d_ranked_a select 3) * -1]] call d_fnc_NetCallEventCTS;
};

if (_exitj) exitWith {
	player setVariable ["d_recdbusy", false];
};

_control = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1000;
_idx = lbCurSel _control;
if (_idx == -1) exitWith {
	player setVariable ["d_recdbusy", false];
};

_torecruit = d_UnitsToRecruit select _idx;
_grp = group player;
_spawnpos = [];
if (player distance d_AI_HUT < 20) then {
	_spawnpos = getPosATL d_AISPAWN;
} else {
	if (!isNil "d_additional_recruit_buildings") then {
		{
			if (!isNil "_x" && {!isNull _x} && {player distance _x < 20}) exitWith {
				_spawnpos = player modelToWorldVisual [0,-15,0];
			};
		} forEach d_additional_recruit_buildings;
	};
};
if (_spawnpos isEqualTo []) exitWith {
	player setVariable ["d_recdbusy", false];
};

_unit = _grp createUnit [_torecruit, _spawnpos, [], 0, "FORM"];
[_unit] join _grp;
_unit setSkill 1;
_unit setRank "PRIVATE";
if (d_with_ranked) then {
	_unit addEventHandler ["handleHeal", d_fnc_HandleHeal];
};
if (getNumber (configFile/"CfgVehicles"/typeOf _unit/"attendant") == 1) then {
	[_unit] execFSM "fsms\AIRevive.fsm";
};
["d_p_group", [_grp, player]] call d_fnc_NetCallEventCTS;

d_current_ai_units pushBack _unit;

_unit call d_fnc_removefak;
_unit call d_fnc_removenvgoggles;

if (d_current_ai_num == d_max_ai) then {
	((uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1010) ctrlShow false;
};

_ctrl = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1011;
if (!ctrlShown _ctrl) then {
	_ctrl ctrlShow true;
};
_ctrl = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1012;
if (!ctrlShown _ctrl) then {
	_ctrl ctrlShow true;
};

_control = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1001;
_ipic = getText (configFile/"cfgVehicles"/_torecruit/"icon");
__TRACE_2("","_torecruit","_ipic")
_pic = if (_ipic == "") then {
	"#(argb,8,8,3)color(1,1,1,0)"
} else {
	getText(configFile/"CfgVehicleIcons"/_ipic)
};
__TRACE_1("","_pic")
_index = _control lbAdd ([_torecruit, "CfgVehicles"] call d_fnc_GetDisplayName);
_control lbSetPicture [_index, _pic];
_control lbSetColor [_index, [1, 1, 0, 0.8]];

_control2 = (uiNamespace getVariable "d_AIRecruitDialog") displayCtrl 1030;
_control2 ctrlSetText format [localize "STR_DOM_MISSIONSTRING_693", d_current_ai_num, d_max_ai];

player setVariable ["d_recdbusy", false];