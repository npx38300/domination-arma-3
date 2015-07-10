//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getconfiggroup.sqf"
#include "x_setup.sqf"

private ["_side", "_type", "_typeunits", "_typegroup", "_ret", "_config", "_cfgn"];
_side = [_this, 0] call BIS_fnc_param;
_type = [_this, 1] call BIS_fnc_param;
_typeunits = [_this, 2] call BIS_fnc_param;
_typegroup = [_this, 3] call BIS_fnc_param;
_ret = [];

_config = configFile/"CfgGroups"/_side/_type/_typeunits/_typegroup;
if (isClass _config) then {
	for "_i" from 0 to (count _config - 1) do {
		_cfgn = _config select _i;
		if (isClass _cfgn) then {_ret pushBack getText (_cfgn/"vehicle")};
	};
};
_ret