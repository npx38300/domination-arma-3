//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_isledefmarkermove.sqf"
#include "x_setup.sqf"

private ["_grp", "_markern"];
_grp = _this;
sleep 30;
if (!isNull _grp && {(_grp call d_fnc_GetAliveUnitsGrp) > 0}) then {
	_markern = str _grp + "i_d_f_m" + str d_IsleDefMarkerMove;
	d_IsleDefMarkerMove = d_IsleDefMarkerMove + 1;
	["d_c_m_g", [_markern, [0,0,0],"ICON",d_e_marker_color,[0.5,0.5],localize "STR_DOM_MISSIONSTRING_964",0,d_isle_defense_marker]] call d_fnc_NetCallEventCTS;
	while {!isNull _grp && {(_grp call d_fnc_GetAliveUnitsGrp) > 0}} do {
		private "_lead";
		_lead = leader _grp;
		if (!isNull _lead) then {
			_markern setMarkerPos (getPosASL _lead);
		};
		sleep (10 + random 10);
	};
	["d_d_m_g", _markern] call d_fnc_NetCallEventCTS;
};