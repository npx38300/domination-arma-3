// by Xeno
//#define __DEBUG__
#define THIS_FILE "init.sqf"
diag_log [diag_frameno, diag_ticktime, time, "Executing Dom init.sqf"];

#include "x_setup.sqf"

[] spawn {
waitUntil {!isNull (findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call d_fnc_Keys"];
};

Parahute_Opened = false;

// just a check to prevent init.sqf running more than once
// shouldn't happen, but we want to be sure :)
if (!isNil "d_init_started") exitWith {
	diag_log [diag_frameno, diag_ticktime, time, "Dom init.sqf executed more than once"];
};
d_init_started = true;

d_IS_HC_CLIENT = !isDedicated && {!hasInterface};

__TRACE_1("","d_IS_HC_CLIENT")

if (isDedicated) then {
	0 spawn {
		private ["_timeout"];
		_timeout = time + 120;
		waitUntil {!isNil "HC_D_UNIT" || {time > _timeout}};
		if (!isNil "HC_D_UNIT") then {
			waitUntil {!isNull HC_D_UNIT || {time > _timeout}};
			if (!isNull HC_D_UNIT) then {
				d_HC_CLIENT_OBJ = HC_D_UNIT;
				d_HC_CLIENT_OBJ_NAME = name HC_D_UNIT;
				__TRACE_2("","d_HC_CLIENT_OBJ","d_HC_CLIENT_OBJ_NAME")
			};
		};
	};
};

if (isMultiplayer && {!isDedicated}) then {
	enableRadio false;
	showChat false;
	0 fadeSound 0;
	titleText ["", "BLACK FADED"];
};

enableSaving [false,false];
enableTeamSwitch false;

d_of_ex_id = ["DOM_OF1_ID", "onEachFrame", {
	if (isNil "d_d_init_ready") then {
		call compile preprocessFileLineNumbers "d_init.sqf";
	};
	[d_of_ex_id, "onEachFrame"] call bis_fnc_removeStackedEventHandler;
	d_of_ex_id = nil;
}] call bis_fnc_addStackedEventHandler;

diag_log [diag_frameno, diag_ticktime, time, "Dom init.sqf processed"];
