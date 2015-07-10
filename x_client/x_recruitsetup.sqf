// by Xeno
#define THIS_FILE "x_recruitsetup.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

player reveal d_AI_HUT;

d_AI_HUT addAction [(localize "STR_DOM_MISSIONSTRING_314") call d_fnc_BlueText, {_this call d_fnc_recruitaiaction}];

if (!isNil "d_additional_recruit_buildings") then {
	{
		if (!isNil "_x" && {!isNull _x}) then {
			["d_RecruitB_" + str _forEachIndex, getPosASL _x,"ICON","ColorYellow",[0.5,0.5],localize "STR_DOM_MISSIONSTRING_313",0,"mil_dot"] call d_fnc_CreateMarkerLocal;

			_x addAction [(localize "STR_DOM_MISSIONSTRING_314") call d_fnc_BlueText, {_this call d_fnc_recruitaiaction}];
			player reveal _x;
		};
	} forEach d_additional_recruit_buildings;
};

d_current_ai_num = 0;
d_current_ai_units = [];

if (isNil "d_UnitsToRecruit") then {
	_pchar = switch (d_player_side) do {
		case blufor: {"B"};
		case opfor: {"O"};
		case independent: {"I"};
	};
	d_UnitsToRecruit = [];
	{
		d_UnitsToRecruit pushBack (_pchar + _x);
	} forEach ["_Soldier_F", "_soldier_AR_F", "_soldier_exp_F", "_Soldier_GL_F", "_soldier_M_F", "_medic_F", "_soldier_repair_F", "_soldier_LAT_F"];
};

player setVariable ["d_recdbusy", false];
