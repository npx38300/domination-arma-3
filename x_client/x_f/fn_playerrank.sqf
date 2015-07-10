//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_playerrank.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_score","_d_player_old_score","_d_player_old_rank"];
_score = score player;
_d_player_old_score = player getVariable "d_player_old_score";
if (isNil "_d_player_old_score") then {_d_player_old_score = 0};
_d_player_old_rank = player getVariable "d_player_old_rank";
if (isNil "_d_player_old_rank") then {_d_player_old_rank = 0};
if (_score < (d_points_needed select 0) && {_d_player_old_rank != 0}) exitWith {
	if (_d_player_old_score >= (d_points_needed select 0)) then {[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_664", _d_player_old_rank call d_fnc_GetRankIndex2]};
	_d_player_old_rank = 0;
	player setRank (_d_player_old_rank call d_fnc_GetRankIndex2);
	player setVariable ["d_player_old_rank", _d_player_old_rank];
	player setVariable ["d_player_old_score", _score];
};
if (_score < (d_points_needed select 1) && {_score >= (d_points_needed select 0)} && {_d_player_old_rank != 1}) exitWith {
	if (_d_player_old_score < (d_points_needed select 1)) then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_665");
		playSound "d_fanfare";
	} else {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_666", _d_player_old_rank call d_fnc_GetRankIndex2];
	};
	_d_player_old_rank = 1;
	player setRank (_d_player_old_rank  call d_fnc_GetRankIndex2);
	player setVariable ["d_player_old_score", _score];
	player setVariable ["d_player_old_rank", _d_player_old_rank];
};
if (_score < (d_points_needed select 2) && {_score >= (d_points_needed select 1)} && {_d_player_old_rank != 2}) exitWith {
	if (_d_player_old_score < (d_points_needed select 2)) then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_667");
		playSound "d_fanfare";
	} else {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_668", _d_player_old_rank call d_fnc_GetRankIndex2];
	};
	_d_player_old_rank = 2;
	player setRank (_d_player_old_rank call d_fnc_GetRankIndex2);
	player setVariable ["d_player_old_score", _score];
	player setVariable ["d_player_old_rank", _d_player_old_rank];
};
if (_score < (d_points_needed select 3) && {_score >= (d_points_needed select 2)} && {_d_player_old_rank != 3}) exitWith {
	if (_d_player_old_score < (d_points_needed select 3)) then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_669");
		playSound "d_fanfare";
	} else {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_670", _d_player_old_rank call d_fnc_GetRankIndex2];
	};
	_d_player_old_rank = 3;
	player setRank (_d_player_old_rank call d_fnc_GetRankIndex2);
	player setVariable ["d_player_old_score", _score];
	player setVariable ["d_player_old_rank", _d_player_old_rank];
};
if (_score < (d_points_needed select 4) && {_score >= (d_points_needed select 3)} && {_d_player_old_rank != 4}) exitWith {
	if (_d_player_old_score < (d_points_needed select 4)) then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_671");
		playSound "d_fanfare";
	} else {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_672", _d_player_old_rank call d_fnc_GetRankIndex2];
	};
	_d_player_old_rank = 4;
	player setRank (_d_player_old_rank call d_fnc_GetRankIndex2);
	player setVariable ["d_player_old_score", _score];
	player setVariable ["d_player_old_rank", _d_player_old_rank];
};
if (_score < (d_points_needed select 5) && {_score >= (d_points_needed select 4)} && {_d_player_old_rank != 5}) exitWith {		
	if (_d_player_old_score < (d_points_needed select 4)) then {
		[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_673");
		playSound "d_fanfare";
	} else {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_674", _d_player_old_rank call d_fnc_GetRankIndex2];
	};
	_d_player_old_rank = 5;
	player setRank (_d_player_old_rank call d_fnc_GetRankIndex2);
	player setVariable ["d_player_old_score", _score];
	player setVariable ["d_player_old_rank", _d_player_old_rank];
};
if (_score >= (d_points_needed select 5) && {_d_player_old_rank != 6}) exitWith {
	_d_player_old_rank = 6;
	player setRank (_d_player_old_rank call d_fnc_GetRankIndex2);
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_675");
	playSound "d_fanfare";
	player setVariable ["d_player_old_score", _score];
	player setVariable ["d_player_old_rank", _d_player_old_rank];
};