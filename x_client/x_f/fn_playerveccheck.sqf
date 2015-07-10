// by Xeno
#define THIS_FILE "fn_playerveccheck.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_vec", "_not_allowed", "_needed_rank", "_index"];
_vec = vehicle player;
_not_allowed = false;
_needed_rank = "";

if (isNil {_vec getVariable "d_vec_type"}) then {
	_index = rankId player;
	_vrs = d_ranked_a select 8;
	
	if (_vec isKindOf "LandVehicle") then {
		if (_vec isKindOf "Wheeled_APC" || {_vec isKindOf "Wheeled_APC_F"}) then {
			_indexsb = (toUpper (_vrs select 0)) call d_fnc_GetRankIndex;
			if (_index < _indexsb) then {
				_not_allowed = true;
				_needed_rank = _vrs select 0;
			};
		} else {
			if (_vec isKindOf "Tank") then {
				_indexta = (toUpper (_vrs select 1)) call d_fnc_GetRankIndex;
				if (_index < _indexta) then {
					_not_allowed = true;
					_needed_rank = _vrs select 1;
				};
			};
		};
	} else {
		if (_vec isKindOf "Air") then {
			if (_vec isKindOf "Helicopter") then {
				_indexheli = (toUpper (_vrs select 2)) call d_fnc_GetRankIndex;
				if (_index < _indexheli) then {
					_not_allowed = true;
					_needed_rank = _vrs select 2;
				};
			} else {
				if (_vec isKindOf "Plane") then {
					_indexplane = (toUpper (_vrs select 3)) call d_fnc_GetRankIndex;
					if (_index < _indexplane) then {
						_not_allowed = true;
						_needed_rank = _vrs select 3;
					};
				};
			};
		};
	};
};

if (_not_allowed) then {
	player action["getOut", _vec];
	[format [localize "STR_DOM_MISSIONSTRING_308", (rank player) call d_fnc_GetRankString, _needed_rank, [typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName], "HQ"] call d_fnc_HintChatMsg;
};
