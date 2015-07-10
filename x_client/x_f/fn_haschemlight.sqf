//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_haschemlight.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_chemar"];
_chemar = [];
{
	if (getText(configFile/"CfgMagazines"/_x/"nameSound") == "Chemlight" && {!(_x in _chemar)}) then {
		_chemar pushBack _x;
	};
} forEach (magazines player);

_chemar