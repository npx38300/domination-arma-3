//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_adselchanged.sqf"
#include "x_setup.sqf"

#define __CTRL2(A) (_display displayCtrl A)

if (isDedicated) exitWith {};

private ["_ctrl", "_display", "_ctrlinfo", "_selection", "_control", "_selectedIndex", "_strp", "_unit", "_posunit", "_sel", "_endtime"];

disableSerialization;

if (!d_pisadminp && {isMultiplayer}) exitWith {
	["d_p_f_b_k", [player, d_name_pl, 3]] call d_fnc_NetCallEventCTS;
};

_selection = [_this, 0] call BIS_fnc_param;

_selectedIndex = _selection select 1;
if (_selectedIndex == -1) exitWith {};

_control = _selection select 0;
_control ctrlEnable false;
_strp = _control lbData _selectedIndex;

_unit = missionNamespace getVariable _strp;
d_a_d_cur_uid = getPlayerUID _unit;
d_a_d_cur_unit_name = name _unit;
__TRACE_1("adselchanged","_unit")
d_u_r_inf = nil;
_display = (uiNamespace getVariable "d_AdminDialog");
d_a_d_cur_name = _control lbText _selectedIndex;
_ctrlinfo = __CTRL2(1002);
_ctrlinfo ctrlSetText format [localize "STR_DOM_MISSIONSTRING_689", d_a_d_cur_name];
["d_g_p_inf", [player, d_a_d_cur_uid]] call d_fnc_NetCallEventCTS;

["d_admin_marker", [0,0,0],"ICON","ColorBlack",[1,1],"",0,"hd_dot"] call d_fnc_CreateMarkerLocal;
"d_admin_marker" setMarkerTextLocal d_a_d_cur_name;
_posunit = visiblePositionASL _unit;
"d_admin_marker" setMarkerPosLocal _posunit;

_ctrl = __CTRL2(11010);
_ctrl ctrlmapanimadd [0.0, 1.00, getPosASL (vehicle player)];
_ctrl ctrlmapanimadd [1.2, 1.00, _posunit];
_ctrl ctrlmapanimadd [0.5, 0.30, _posunit];
ctrlmapanimcommit _ctrl;

_endtime = time + 30;
waitUntil {!isNil "d_u_r_inf" || {!d_admin_dialog_open} || {!alive player} || {time > _endtime}};

d_u_r_inf = d_u_r_inf select 1;

if (d_u_r_inf isEqualTo [] || {!d_admin_dialog_open} || {!alive player} || {time > _endtime}) exitWith {};

_control ctrlEnable true;

if (d_u_r_inf isEqualTo []) exitWith {_ctrlinfo ctrlSetText format [localize "STR_DOM_MISSIONSTRING_690", d_a_d_cur_name]};

_ctrlinfo ctrlSetText format [localize "STR_DOM_MISSIONSTRING_691", d_a_d_cur_name];

__CTRL2(1003) ctrlSetText d_a_d_cur_name;
__CTRL2(1004) ctrlSetText d_a_d_cur_uid;
__CTRL2(1005) ctrlSetText str _unit;

_sel = 7;
__CTRL2(1006) ctrlSetText str(d_u_r_inf select _sel);
__CTRL2(1009) ctrlSetText str(score _unit);
__CTRL2(1007) ctrlEnable ((d_u_r_inf select _sel) >= 1);
__CTRL2(1008) ctrlEnable (d_a_d_cur_name != d_name_pl);
__CTRL2(1010) ctrlEnable (d_a_d_cur_name != d_name_pl);