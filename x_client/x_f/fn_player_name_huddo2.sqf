//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_player_name_huddo2.sqf"
#include "x_setup.sqf"

d_pnhuddo2_frskip = d_pnhuddo2_frskip + 1;
if (d_pnhuddo2_frskip == 2) exitWith {
	d_pnhuddo2_frskip = 0;
};
private ["_ct", "_ctrl", "_name", "_icon", "_rankpic"];
disableSerialization;
if (!d_show_pname_hud && {!visibleMap} && {isNil "d_is_sat_on"}) then {
	_ct = cursorTarget;
	if (!isNull _ct && {_ct isKindOf "CAManBase"} && {alive _ct} && {!(player getVariable ["xr_pluncon", false])} && {_ct != player} && {((positionCameraToWorld [0,0,0]) distance _ct) <= (d_dist_pname_hud / 2)} && {side (group _ct) getFriend side (group player) >= 0.6}) then { // && {isPlayer _ct}
		d_pnhuddo2_endtime = time + 0.8;
		if (!d_showPlayerNameRSC_shown) then {
			4769 cutRsc ["d_showPlayerNameRsc", "PLAIN"];
			d_showPlayerNameRSC_shown = true;
			0 spawn d_fnc_dosshowhuddo2spawn;
		};
		
		_ctrl = (uiNamespace getVariable "d_showPlayerNameRsc") displayCtrl 1000;
		_rankpic = (rank _ct) call d_fnc_getrankpic;
		_name = if (!(_ct getVariable ["xr_pluncon", false])) then {if (isPlayer _ct) then {name _ct} else {getText(configFile/"CfgVehicles"/typeOf _ct/"displayName")}} else {(name _ct) + d_phud_loc883};
		_icon = getText(configFile/"CfgVehicles"/typeOf _ct/"Icon");
		if (_icon != "") then {
			_icon = getText(configFile/"CfgVehicleIcons"/_icon);
		};
		_ctrtxt =  if (getNumber(configFile/"CfgVehicles"/typeOf player/"attendant") != 1) then {
			format ["<img color='#FFFFFF' size='1.0' image='%1'/><t color='#b5f279' size='1.2'> %2</t><img color='#FFFFFF' size='1.0' image='%3'/><br/>",
				_rankpic,
				_name,
				_icon
			];
		} else {
			format ["<img color='#FFFFFF' size='1.0' image='%1'/><t color='#b5f279' size='1.2'> %2</t><img color='#FFFFFF'size='1.0' image='%3'/><br/><t color='#b5f279' size='0.8'>Damage: </t><t color='#FFFFFF' size='0.8'>%4</t>",
				_rankpic,
				_name,
				_icon,
				str(round ((damage _ct) * 90))
			];
		};
		_ctrl ctrlSetStructuredText parseText _ctrtxt;
	};
} else {
	if (d_show_pname_hud) then {
		["itemRemove", ["dom_player_hud2"]] call bis_fnc_loop;
	};
};