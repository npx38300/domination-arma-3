//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_artmselchanged.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_ctrlmap", "_selectedIndex", "_disp", "_lbctrl", "_name", "_aridx", "_mname"];
disableSerialization;

__TRACE_1("","_this")

_disp = (uiNamespace getVariable "d_ArtilleryDialog2");
//!ctrlEnabled (_disp displayCtrl 50)) exitWith {};

_selectedIndex = _this select 1;
if (_selectedIndex == -1) exitWith {};

_lbctrl = _this select 0;

_name = _lbctrl lbText _selectedIndex;
_aridx = _lbctrl lbValue _selectedIndex;
_mname = _lbctrl lbData _selectedIndex;

_arele = d_cur_art_marker_ar select _aridx;

_ctrl = _disp displayCtrl 2000;
_ctrl ctrlSetText _name;
_ctrl = _disp displayCtrl 2001;
_ctrl ctrlSetText getText(configFile/"CfgMagazines"/(_arele select 2)/"displayName");
_ctrl = _disp displayCtrl 2002;
_ctrl ctrlSetText str (_arele select 3);

_ctrlmap = _disp displayCtrl 1001;
ctrlMapAnimClear _ctrlmap;

_end_pos = markerPos _mname;
__TRACE_2("","_mname","_end_pos")
_ctrlmap ctrlmapanimadd [0.0, 1.00, d_cur_artm_map_startpos];
_ctrlmap ctrlmapanimadd [1.2, 1.00, _end_pos];
_ctrlmap ctrlmapanimadd [0.5, 0.30, _end_pos];
ctrlmapanimcommit _ctrlmap;
d_cur_artm_map_startpos = _end_pos;
