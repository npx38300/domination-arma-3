// by Xeno
#define THIS_FILE "fn_deleteplayermarker.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

if (d_show_player_marker > 0) then {
	switch (d_show_player_marker) do {
		case 1: {systemChat (localize "STR_DOM_MISSIONSTRING_205")};
		case 2: {systemChat (localize "STR_DOM_MISSIONSTRING_206")};
		case 3: {systemChat (localize "STR_DOM_MISSIONSTRING_208")};
	};
};

if (d_show_player_marker == 0) then {
	systemChat (localize "STR_DOM_MISSIONSTRING_209");
	0 spawn {
		sleep 2.123;
		{
			_x setMarkerPosLocal [0,0];
			_x setMarkerAlphaLocal 0;
		} forEach d_player_entities;
		systemChat (localize "STR_DOM_MISSIONSTRING_210");
	};
} else {
	{
		_x setMarkerAlphaLocal 1;
	} forEach d_player_entities;
};