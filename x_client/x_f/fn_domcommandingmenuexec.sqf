// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_domcommandingmenuexec.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

__TRACE_1("","_this")

if (!alive player || {player getVariable ["xr_pluncon", false]} || {player getVariable ["d_isinaction", false]}) exitWith {	
	showCommandingMenu "";
	d_DomCommandingMenuBlocked = false;
	d_commandingMenuIniting = false;
};
d_commandingMenuIniting = true;
showCommandingMenu "";
switch (_this) do {
	case 0: {d_commandingMenuCode = {call d_fnc_showstatus}};
	case 1: {d_commandingMenuCode = {call d_fnc_artillery}};
	case 2: {d_commandingMenuCode = {0 spawn d_fnc_calldrop}};
	case 5: {d_commandingMenuCode = {0 spawn d_fnc_spawn_mash}};
	case 6: {d_commandingMenuCode = {0 spawn d_fnc_spawn_farp}};
	case 7: {d_commandingMenuCode = {call d_fnc_adminspectate}};
	case 8: {d_commandingMenuCode = {d_in_backpack = true;0 spawn d_fnc_backpack;d_commandingMenuIniting = false}};
	case 15: {d_commandingMenuCode = {"Chemlight_green" call d_fnc_attachchemlight}};
	case 16: {d_commandingMenuCode = {"Chemlight_red" call d_fnc_attachchemlight}};
	case 17: {d_commandingMenuCode = {"Chemlight_yellow" call d_fnc_attachchemlight}};
	case 18: {d_commandingMenuCode = {"Chemlight_blue" call d_fnc_attachchemlight}};
	case 20: {d_commandingMenuCode = {call d_fnc_detachchemlight}};
};
d_DomCommandingMenuBlocked = false;