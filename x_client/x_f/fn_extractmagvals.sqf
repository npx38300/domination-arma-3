// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_extractmagvals.sqf"
#include "x_setup.sqf"

private ["_epos", "_spos"];
__TRACE_1("","_this")

_epos = -1;
_spos = -1;
for "_i" from (count _this - 1) to 0 step -1 do {
	_c = _this select [_i, 1];
	if (_c == "/") then { //    /
		_epos = _i;
	};
	if (_c == "(") exitWith { //  (
		_spos = _i + 1;
	};
};

parseNumber (_this select [_spos, _epos - _spos])
