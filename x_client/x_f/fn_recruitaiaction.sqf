// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_recruitaiaction.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

if (_this select 1 != player) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_1565");
};

private ["_grpplayer"];

__TRACE_1("","_this")

_grpplayer = group player;

if (player != leader _grpplayer) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_311");
};

if (player distance (_this select 0) > 50) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_312");
};

d_current_ai_num = 0;
{
	if (!isPlayer _x && {alive _x}) then {
		d_current_ai_num = d_current_ai_num + 1;
	};
} forEach units _grpplayer;

createDialog "d_AIRecruitDialog";