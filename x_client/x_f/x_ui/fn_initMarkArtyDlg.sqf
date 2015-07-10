// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_initMarkArtyDlg.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

private ["_ctrl", "_rank", "_sels", "_magsv", "_ammonv"];

_magsv = [];
_cfgmagx = configFile/"CfgMagazines";
{
	if !(_x in _magsv) then {
		_xammo = getText(_cfgmagx/_x/"ammo");
		if (getText(configFile/"CfgAmmo"/_xammo/"submunitionAmmo") != "Mo_ClassicMineRange") then {
			_magsv pushBack _x;
		};
	};
	__TRACE_1("","_x")
} forEach getArray(configFile/"CfgVehicles"/typeOf (d_ao_arty_vecs select 0)/"Turrets"/"MainTurret"/"magazines");

_ammonv = [];
_ammonv resize (count _magsv);
{
	_ammonv set [_forEachIndex, getText(configFile/"CfgMagazines"/_x/"displayName")];
} forEach _magsv;

__TRACE_2("","_magsv","_ammonv")

_ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 888;
{
	_idx = _ctrl lbAdd _x;
	_ctrl lbSetData [_idx, _magsv select _forEachIndex];
} forEach _ammonv;
_ctrl lbSetCurSel 0;

_ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 889;
if (!d_with_ranked) then {
	{_ctrl lbAdd _x} forEach ["1", "2", "3"];
} else {
	_rank = rank player;
	_sels = if (_rank in ["PRIVATE","CORPORAL"]) then {
		["1"]
	} else {
		if (_rank in ["SERGEANT","LIEUTENANT"]) then {
			["1", "2"]
		} else {
			["1", "2", "3"]
		};
	};
	{_ctrl lbAdd _x} forEach _sels;
};
_ctrl lbSetCurSel 0;
ctrlSetFocus ((uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 1212);

_ctrlmap = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 11111;
_ctrlmap ctrlMapAnimAdd [0.5, 0.02, markerPos "d_temp_mark_arty_marker"];
ctrlMapAnimCommit _ctrlmap;
