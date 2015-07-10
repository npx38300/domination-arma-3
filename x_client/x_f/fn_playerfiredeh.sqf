//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_playerfiredeh.sqf"
#include "x_setup.sqf"

if (animationState player == "halofreefall_non" && {(_this select 4) isKindOf "TimeBombCore"}) then {
	deleteVehicle (_this select 6);
	player addMagazine (_this select 5);
} else {
	private "_num";
	if !(player getVariable ["d_p_isadmin", false]) then {
		if (player in (list d_player_base_trig)) then {
			private "_ta";
			_ta = _this select 4;
			if (_ta isKindOf "TimeBombCore" || {getText(configFile/"CfgAmmo"/_ta/"simulation") in ["shotMine"]}) then {
				if (count _this > 6) then {
					deleteVehicle (_this select 6);
				};
				if (d_kick_base_satchel == 0) then {
					["d_p_f_b_k", [player, d_name_pl,1]] call d_fnc_NetCallEventCTS;
				} else {
					["d_p_bs", [player, d_name_pl,1]] call d_fnc_NetCallEventCTS;
				};
			} else {
				if (!d_there_are_enemies_atbase && {!d_enemies_near_base} && {!(getText(configFile/"CfgAmmo"/_ta/"simulation") in ["shotSmoke", "shotIlluminating", "shotNVGMarker", "shotCM", "shotSmokeX"])}) then {
					_num = (player getVariable "d_p_f_b") + 1;
					player setVariable ["d_p_f_b", _num];
					if !(player in (list d_player_base_trig2)) then {
						if (d_player_kick_shootingbase != 1000) then {
							if (_num >= d_player_kick_shootingbase) then {
								if (isNil {player getVariable "d_pfbk_announced"}) then {
									["d_p_f_b_k", [player, d_name_pl,0]] call d_fnc_NetCallEventCTS;
									player setVariable ["d_pfbk_announced", true];
								};
							} else {
								hint (localize "STR_DOM_MISSIONSTRING_537");
							};
						} else {
							if (_num >= d_player_kick_shootingbase) then {
								["d_p_bs", [player, d_name_pl,0]] call d_fnc_NetCallEventCTS;
							};
						};
					};
				};
			};
		} else {
			player setVariable ["d_p_f_b", 0];
		};
	};
};