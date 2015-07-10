// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_checksmshothd.sqf"
#include "x_setup.sqf"

if (!alive (_this select 0)) exitWith {
	(_this select 0) removeAllEventHandlers "handleDamage";
};

if (toUpper(getText(configFile/"CfgAmmo"/(_this select 4)/"simulation")) in d_hd_sim_types) then {
	_this select 2
} else {
	0
}