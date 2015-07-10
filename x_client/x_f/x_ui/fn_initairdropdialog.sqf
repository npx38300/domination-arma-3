// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_initairdropdialog.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_array","_display"];

disableSerialization;

#define CTRL(A) (_display displayCtrl A)

_display = (uiNamespace getVariable "d_AirDropDialog");

_array = d_x_drop_array select 0;
if (_array isEqualTo []) then {
	CTRL(11002) ctrlShow false;
} else {
	CTRL(11002) ctrlSetText (_array select 0);
};
_array = d_x_drop_array select 1;
if (_array isEqualTo []) then {
	CTRL(11003) ctrlShow false;
} else {
	CTRL(11003) ctrlSetText (_array select 0);
};
_array = d_x_drop_array select 2;
if (_array isEqualTo []) then {
	CTRL(11004) ctrlShow false;
} else {
	CTRL(11004) ctrlSetText (_array select 0);
};
