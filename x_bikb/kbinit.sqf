// by Xeno
#define THIS_FILE "kbinit.sqf"
#include "x_setup.sqf"
private ["_grpen", "_grpru", "_kbscript", "_pside"];

if (isServer) then {
#ifdef __OWN_SIDE_BLUFOR__
	_grpen = [blufor] call d_fnc_creategroup;
	d_hq_logic_en1 = _grpen createUnit ["Logic",[0,0,0],[],0,"NONE"];
	[d_hq_logic_en1] joinSilent _grpen;
	d_hq_logic_en1 enableSimulationGlobal false;
	publicVariable "d_hq_logic_en1";
	d_hq_logic_en1 setVariable ["d_hq_logic_name", "d_hq_logic_en1"];
	d_hq_logic_en1 setVariable ["d_hq_logic_side", blufor];
	d_hq_logic_en1 addEventHandler ["killed",{_this call d_fnc_kEHflogic}];
	
	//_grpen = [blufor] call d_fnc_creategroup;
	d_hq_logic_en2 = _grpen createUnit ["Logic",[0,0,0],[],0,"NONE"];
	[d_hq_logic_en2] joinSilent _grpen;
	d_hq_logic_en2 addEventHandler ["handleDamage",{0}];
	d_hq_logic_en2 enableSimulationGlobal false;
	publicVariable "d_hq_logic_en2";
	d_hq_logic_en2 setVariable ["d_hq_logic_name", "d_hq_logic_en2"];
	d_hq_logic_en2 setVariable ["d_hq_logic_side", blufor];
	d_hq_logic_en2 addEventHandler ["killed",{_this call d_fnc_kEHflogic}];
#endif

#ifdef __OWN_SIDE_OPFOR__
	_grpru = [opfor] call d_fnc_creategroup;
	d_hq_logic_ru1 = _grpru createUnit ["Logic",[0,0,0],[],0,"NONE"];
	[d_hq_logic_ru1] joinSilent _grpru;
	d_hq_logic_ru1 enableSimulationGlobal false;
	d_hq_logic_ru1 addEventHandler ["handleDamage",{0}];
	publicVariable "d_hq_logic_ru1";
	d_hq_logic_ru1 setVariable ["d_hq_logic_name", "d_hq_logic_ru1"];
	d_hq_logic_ru1 setVariable ["d_hq_logic_side", opfor];
	d_hq_logic_ru1 addEventHandler ["killed",{_this call d_fnc_kEHflogic}];
	
	//_grpru = [opfor] call d_fnc_creategroup;
	d_hq_logic_ru2 = _grpru createUnit ["Logic",[0,0,0],[],0,"NONE"];
	[d_hq_logic_ru2] joinSilent _grpru;
	d_hq_logic_ru2 enableSimulationGlobal false;
	d_hq_logic_ru2 addEventHandler ["handleDamage",{0}];
	publicVariable "d_hq_logic_ru2";
	d_hq_logic_ru2 setVariable ["d_hq_logic_name", "d_hq_logic_ru2"];
	d_hq_logic_ru2 setVariable ["d_hq_logic_side", opfor];
	d_hq_logic_ru2 addEventHandler ["killed",{_this call d_fnc_kEHflogic}];
#endif
};

_kbscript = "x_bikb\domkba3.bikb";

#ifdef __OWN_SIDE_OPFOR__
d_hq_logic_ru1 kbAddTopic["HQ_E",_kbscript];
d_hq_logic_ru1 kbAddTopic["HQ_ART_E",_kbscript];
d_hq_logic_ru1 setIdentity "DHQ_OP1";
d_hq_logic_ru1 setRank "COLONEL";
d_hq_logic_ru1 setGroupId ["HQ"];
d_hq_logic_ru1 setVariable ["d_kddata", [["HQ_E", "HQ_ART_E"], "DHQ_OP1","HQ"]];

d_hq_logic_ru2 kbAddTopic["HQ_E",_kbscript];
d_hq_logic_ru2 setIdentity "DHQ_OP2";
d_hq_logic_ru2 setRank "COLONEL";
d_hq_logic_ru2 setGroupId ["HQ1"];
d_hq_logic_ru2 setVariable ["d_kddata", [["HQ_E"], "DHQ_OP2","HQ1"]];
#endif

#ifdef __OWN_SIDE_BLUFOR__
d_hq_logic_en1 kbAddTopic["HQ_W",_kbscript];
d_hq_logic_en1 kbAddTopic["HQ_ART_W",_kbscript];
d_hq_logic_en1 setIdentity "DHQ_BF1";
d_hq_logic_en1 setRank "COLONEL";
d_hq_logic_en1 setGroupId ["Crossroad"];
d_hq_logic_en1 setVariable ["d_kddata", [["HQ_W", "HQ_ART_W"], "DHQ_BF1","Crossroad"]];

d_hq_logic_en2 kbAddTopic["HQ_W",_kbscript];
d_hq_logic_en2 setIdentity "DHQ_BF2";
d_hq_logic_en2 setRank "COLONEL";
d_hq_logic_en2 setGroupId ["Crossroad1"];
d_hq_logic_en2 setVariable ["d_kddata", [["HQ_W"], "DHQ_BF2","Crossroad1"]];
#endif

d_kb_logic1 = switch (d_enemy_side) do {
	case "OPFOR": {d_hq_logic_en1};
	case "BLUFOR": {d_hq_logic_ru1};
};
d_kb_logic2 = switch (d_enemy_side) do {
	case "OPFOR": {d_hq_logic_en2};
	case "BLUFOR": {d_hq_logic_ru2};
};
d_kb_topic_side = switch (d_enemy_side) do {
	case "OPFOR": {"HQ_W"};
	case "BLUFOR": {"HQ_E"};
};
d_kb_topic_side_arti = switch (d_enemy_side) do {
	case "OPFOR": {"HQ_ART_W"};
	case "BLUFOR": {"HQ_ART_E"};
};

if (!isDedicated) then {
	sleep 1;
	if (isMultiplayer) then {
		waitUntil {sleep 0.220;!isNil "d_still_in_intro"};
		waitUntil {sleep 0.220;!d_still_in_intro};
	};
	_pside = side (group player);
	switch (_pside) do {
		case blufor: {player kbAddTopic["HQ_W",_kbscript]};
		case opfor: {player kbAddTopic["HQ_E",_kbscript]};
	};
	_strp = str player;
	player kbAddTopic["PL" + _strp,_kbscript];
	d_kb_logic1 kbAddTopic["PL" + _strp,_kbscript];
	if (!d_with_ai && {d_with_ai_features != 0}) then {
		if (_strp in d_can_use_artillery) then {
			switch (_pside) do {
				case blufor: {player kbAddTopic["HQ_ART_W",_kbscript]};
				case opfor: {player kbAddTopic["HQ_ART_E",_kbscript]};
			};
		};
	} else {
		switch (_pside) do {
			case blufor: {player kbAddTopic["HQ_ART_W",_kbscript]};
			case opfor: {player kbAddTopic["HQ_ART_E",_kbscript]};
		};
	};
};

