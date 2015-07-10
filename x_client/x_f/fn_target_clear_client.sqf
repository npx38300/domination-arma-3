// by Xeno
#define THIS_FILE "fn_target_clear_client.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_cur_tgt_name","_tgt_ar","_extra_bonusn"];

_extra_bonusn = _this;

_tgt_ar = d_target_names select d_current_target_index;
_cur_tgt_name = _tgt_ar select 1;

if (!isNil "d_task1") then {d_task1 setTaskState "Succeeded"};

if (!isNil "d_current_task") then {
	d_current_task setTaskState "Succeeded";
	["TaskSucceeded",[d_current_task, (taskDescription d_current_task) select 1]] call bis_fnc_showNotification;
};

if (count d_resolved_targets < d_MainTargets) then {
	_mt_str = format [localize "STR_DOM_MISSIONSTRING_570", _cur_tgt_name];
	if (_extra_bonusn != "") then {
		_bonus_string = format[localize "STR_DOM_MISSIONSTRING_571", [_extra_bonusn, "CfgVehicles"] call d_fnc_GetDisplayName];
		
		hint composeText[
			parseText("<t color='#f02b11ed' size='1'>" + _mt_str + "</t>"), lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_572", lineBreak,lineBreak,
			_bonus_string, lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_573"
		];
	} else {
		hint composeText[
			parseText("<t color='#f02b11ed' size='1'>" + _mt_str + "</t>"), lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_572", lineBreak,lineBreak,
			localize "STR_DOM_MISSIONSTRING_573"
		];
	};
	
	if (d_with_ranked) then {
		_cur_tgt_pos = _tgt_ar select 0;
		if (player distance _cur_tgt_pos < (d_ranked_a select 10)) then {
			[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_574", d_ranked_a select 9];
			0 spawn {
				scriptName "spawn_x_target_clear_client_sendscore";
				sleep (0.5 + random 2);
				["d_pas", [player, d_ranked_a select 9]] call d_fnc_NetCallEventCTS;
			};
		};
	};
} else {
	hint  composeText[
		parseText("<t color='#f02b11ed' size='1'>" + format [localize "STR_DOM_MISSIONSTRING_570", _cur_tgt_name] + "</t>"), lineBreak,lineBreak,
		localize "STR_DOM_MISSIONSTRING_572"
	];
};

sleep 2;

if !(isServer && {!isDedicated}) then {
	d_current_target_index = -1; publicVariable "d_current_target_index";
};
