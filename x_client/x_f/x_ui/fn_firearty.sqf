//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_firearty.sqf"
#include "x_setup.sqf"

if (isDedicated) exitWith {};

if !(d_ari_available) exitWith {[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_149")};

disableSerialization;

private ["_lbctrl", "_idx", "_arele", "_curmar_pos", "_name_shell", "_no"];

_lbctrl = (uiNamespace getVariable "d_ArtilleryDialog2") displayCtrl 1000;
_idx = lbCurSel _lbctrl;
if (_idx == -1) exitWith {};

_arele = d_cur_art_marker_ar select (_lbctrl lbValue _idx);
_curmar_pos = markerPos (_arele select 0);
__TRACE_2("","_arele","_curmar_pos")

_no = [];
_magammoconf = getText(configFile/"CfgMagazines"/(_arele select 2)/"ammo");
_ammoconf = configFile/"CfgAmmo"/_magammoconf;
_is_flare = getText(_ammoconf/"effectFlare") == "CounterMeasureFlare";
_is_smoke = getText(_ammoconf/"submunitionAmmo") == "SmokeShellArty";
__TRACE_3("","_magammoconf","_is_flare","_is_smoke")

if (!_is_flare && {!_is_smoke}) then {
	_man_type = switch (d_own_side) do {
		case "BLUFOR": {"SoldierWB"};
		case "OPFOR": {"SoldierEB"};
		case "INDEPENDENT": {"SoldierGB"};
	};
	_no = _curmar_pos nearEntities [[_man_type], 20];
};

if !(_no isEqualTo []) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_151");
};

_name_shell = getText(configFile/"CfgMagazines"/(_arele select 2)/"displayname");
__TRACE_1("","_name_shell")

if (d_with_ranked && {d_ranked_a select 2 > 0}) then {["d_pas", [player, (d_ranked_a select 2) * -1]] call d_fnc_NetCallEventCTS};
player kbTell [d_kb_logic1, d_kb_topic_side_arti, "ArtilleryRequest", ["1", "", _name_shell, []], ["2", "", str (_arele select 3), []], ["3", "", mapGridPosition _curmar_pos, []], "SIDE"];
["d_ari_type", [_arele select 2, _arele select 3, player, _arele select 0]] call d_fnc_NetCallEventCTS;
d_arti_did_fire = true;
