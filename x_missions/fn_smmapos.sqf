// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_smmapos.sqf"
#include "x_setup.sqf"

private "_res";
_res = [markerPos _this];
for "_i" from 1 to 100 do {
	private "_nm";
	_nm = _this + "_" + str _i;
	if (markerType _nm == "") exitWith {};
	_res pushBack (markerPos _nm);
};
_res
