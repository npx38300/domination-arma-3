// by Xeno
#define THIS_FILE "fn_createnexttargetclient.sqf"
#include "x_setup.sqf"
private ["_cur_tgt_name","_cur_tgt_pos","_t_array"];
if (isDedicated) exitWith {};

sleep 1.012;
_t_array = d_target_names select d_current_target_index;
_cur_tgt_pos = _t_array select 0;
_cur_tgt_name = _t_array select 1;

"d_dummy_marker" setMarkerPosLocal _cur_tgt_pos;

if (!isNil "d_task1") then {d_task1 setTaskState "Succeeded"};

if (d_current_seize != _cur_tgt_name) then {	
	private ["_dtnum", "_dtform", "_dtask"];
	_dtnum = d_current_target_index + 2;
	_dtform = format ["d_task%1", _dtnum];
	missionNamespace setVariable [_dtform, player createSimpleTask [format ["d_obj%1", _dtnum]]];
	_dtask = missionNamespace getVariable _dtform;
	
	_dtask setSimpleTaskDescription [format [localize "STR_DOM_MISSIONSTRING_202", _cur_tgt_name], format [localize "STR_DOM_MISSIONSTRING_203", _cur_tgt_name], format [localize "STR_DOM_MISSIONSTRING_203", _cur_tgt_name]];
	_dtask setTaskState "Created";
	_dtask setSimpleTaskDestination _cur_tgt_pos;
	d_current_task = _dtask;
	player setCurrentTask _dtask;
};

playSound "d_IncomingChallenge2";
if (!d_still_in_intro) then {
	["TaskCreated",[d_current_task, (taskDescription d_current_task) select 1]] call bis_fnc_showNotification;

	hint format [localize "STR_DOM_MISSIONSTRING_204", _cur_tgt_name];
};
