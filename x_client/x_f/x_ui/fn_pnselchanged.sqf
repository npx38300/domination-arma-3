// by Xeno
#define THIS_FILE "fn_pnselchanged.sqf"
#include "x_setup.sqf"
private ["_selection", "_selectedIndex"];

disableSerialization;

_selection = _this select 0;

_selectedIndex = _selection select 1;

if (_selectedIndex == -1) exitWith {};

if (d_show_player_namesx != _selectedIndex) then {
	d_show_player_namesx = _selectedIndex;
	switch (d_show_player_namesx) do {
		case 0: {
			if (d_show_pname_hud) then {
				d_show_pname_hud = false;
				if (d_phudraw3d != -1) then {
					removeMissionEventHandler ["Draw3D", d_phudraw3d];
					d_phudraw3d = -1;
				};
				["itemAdd", ["dom_player_hud2", {call d_fnc_player_name_huddo2}, 0]] call bis_fnc_loop;
			};
			systemChat (localize "STR_DOM_MISSIONSTRING_887");
		};
		case 1: {
			if (!d_show_pname_hud) then {
				d_show_pname_hud = true;
				if (d_phudraw3d != -1) then {
					removeMissionEventHandler ["Draw3D", d_phudraw3d];
					d_phudraw3d = -1;
				};
				d_phudraw3d = addMissionEventHandler ["Draw3D", {call d_fnc_player_name_huddo}];
			};
			systemChat (localize "STR_DOM_MISSIONSTRING_888");
		};
		case 2: {
			if (!d_show_pname_hud) then {
				d_show_pname_hud = true;
				if (d_phudraw3d != -1) then {
					removeMissionEventHandler ["Draw3D", d_phudraw3d];
					d_phudraw3d = -1;
				};
				d_phudraw3d = addMissionEventHandler ["Draw3D", {call d_fnc_player_name_huddo}];
			};
			systemChat (localize "STR_DOM_MISSIONSTRING_890");
		};
	};
};