// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_showstatus.sqf"
#include "x_setup.sqf"
#define __ctrl(vctrl) _ctrl = _display displayCtrl vctrl
#define __ctrl2(ectrl) (_display displayCtrl ectrl)
private ["_ctrl","_cur_tgt_name","_s","_tgt_ar","_display"];
if (isDedicated) exitWith {};

disableSerialization;

createDialog "d_StatusDialog";

d_commandingMenuIniting = false;

_display = (uiNamespace getVariable "d_StatusDialog");

_mmexit = false;
if (player getVariable ["d_p_isadmin", false]) then {
	if (!d_pisadminp && {isMultiplayer}) exitWith {
		["d_p_f_b_k", [player, d_name_pl, 3]] call d_fnc_NetCallEventCTS;
		_mmexit = true;
	};	
} else {
	__ctrl2(123123) ctrlShow false;
};
if (_mmexit) exitWith {};

_tgt_ar = [];
_cur_tgt_name = "";

_cur_tgt_name = if (d_current_target_index != -1) then {
	_tgt_ar = d_target_names select d_current_target_index;
	_tgt_ar select 1
} else {
	localize "STR_DOM_MISSIONSTRING_539"
};

_s = switch (true) do {
	case (d_all_sm_res): {localize "STR_DOM_MISSIONSTRING_522"};
	case (d_cur_sm_idx == -1): {localize "STR_DOM_MISSIONSTRING_540"};
	default {d_cur_sm_txt};
};
__ctrl2(11002) ctrlSetText _s;

if (d_WithRevive == 1) then {
	__ctrl2(30000) ctrlShow false;
	__ctrl2(30001) ctrlShow false;
} else {
	__ctrl2(30001) ctrlSetText str (player getVariable "xr_lives");
};

_intels = "";
{
	if (_x == 1) then {
		_tmp = switch (_forEachIndex) do {
			case 0: {localize "STR_DOM_MISSIONSTRING_542"};
			case 1: {localize "STR_DOM_MISSIONSTRING_543"};
			case 2: {localize "STR_DOM_MISSIONSTRING_544"};
			case 3: {localize "STR_DOM_MISSIONSTRING_545"};
			case 4: {localize "STR_DOM_MISSIONSTRING_546"};
			case 5: {localize "STR_DOM_MISSIONSTRING_547"};
		};
		_intels = _intels + _tmp + "\n";
	};
} forEach d_searchintel;
if (_intels == "") then {
	_intels = localize "STR_DOM_MISSIONSTRING_548";
};
__ctrl2(11018) ctrlSetText _intels;

__ctrl2(11003) ctrlSetText _cur_tgt_name;

_s = format ["%1/%2", count d_resolved_targets + 1, d_MainTargets];
__ctrl2(11006) ctrlSetText _s;

__ctrl2(11233) ctrlSetText str(score player);

__ctrl(11278);
_ctrl ctrlSetText format ["%1/%2", d_campscaptured, d_numcamps];

_s = if (d_weather == 1) then {format [localize "STR_DOM_MISSIONSTRING_551", round(overcast * 100), round(fog * 100)]} else {format [localize "STR_DOM_MISSIONSTRING_549", round(overcast * 100), round (rain * 100)]};
__ctrl2(11013) ctrlSetText _s;

__ctrl(11009);
_ctrl ctrlSetText (localize "STR_DOM_MISSIONSTRING_552");

_s = "";
if (d_current_target_index != -1) then {
	_s = switch (d_sec_kind) do {
		case 1: {
			format [localize "STR_DOM_MISSIONSTRING_554", _cur_tgt_name]
		};
		case 2: {
			format [localize "STR_DOM_MISSIONSTRING_556", _cur_tgt_name]
		};
		case 3: {
			format [localize "STR_DOM_MISSIONSTRING_557", _cur_tgt_name]
		};
		case 4: {
			format [localize "STR_DOM_MISSIONSTRING_559", _cur_tgt_name]
		};
		case 5: {
			format [localize "STR_DOM_MISSIONSTRING_561", _cur_tgt_name]
		};
		case 6: {
			format [localize "STR_DOM_MISSIONSTRING_562", _cur_tgt_name]
		};
		case 7: {
			format [localize "STR_DOM_MISSIONSTRING_563", _cur_tgt_name]
		};
		case 8: {
			format [localize "STR_DOM_MISSIONSTRING_565", _cur_tgt_name]
		};
		case 9: {
			format [localize "STR_DOM_MISSIONSTRING_566", _cur_tgt_name]
		};
		case 10: {
			format [localize "STR_DOM_MISSIONSTRING_567", _cur_tgt_name]
		};
		default {
			localize "STR_DOM_MISSIONSTRING_568"
		};
	};
} else {
	_s = localize "STR_DOM_MISSIONSTRING_568";
};

__ctrl2(11007) ctrlSetText _s;

_rank_p = rank player;
__ctrl2(12010) ctrlSetText (_rank_p call d_fnc_GetRankPic);

__ctrl2(11014) ctrlSetText (_rank_p call d_fnc_GetRankString);

0 spawn {
	scriptName "spawn_waitforstatusdialogclose";
	waitUntil {!d_showstatus_dialog_open || {!alive player} || {player getVariable ["xr_pluncon", false]}};
	if (d_showstatus_dialog_open) then {closeDialog 0};
};