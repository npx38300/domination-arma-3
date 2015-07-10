// by Xeno
#define THIS_FILE "fn_createsecondary.sqf"
#include "x_setup.sqf"

#define __getPos \
_poss = [_posarx, _mtradius] call d_fnc_GetRanPointCircleBig;\
if (!(_poss isEqualTo []) && {isOnRoad _poss}) then {_poss = []};\
while {_poss isEqualTo []} do {\
	_poss = [_posarx, _mtradius] call d_fnc_GetRanPointCircleBig;\
	if (!(_poss isEqualTo []) && {isOnRoad _poss}) then {_poss = []};\
}

#define __specops \
_newgroup = [d_side_enemy] call d_fnc_creategroup;\
[_poss, ([#specops, d_enemy_side] call d_fnc_getunitlist) select 0, _newgroup] spawn d_fnc_makemgroup;\
sleep 1.0112;\
_newgroup allowFleeing 0;\
_newgroup setVariable ["d_defend", true]; \
[_newgroup, _poss] spawn d_fnc_taskDefend; \
[_newgroup, 1] call d_fnc_setGState;

private ["_poss", "_newgroup", "_vehicle", "_mtmhandle", "_dummy", "_act2", "_nrcamps", "_wf", "_flagPole", "_trg_center", "_posarx"];
if !(call d_fnc_checkSHC) exitWith {};

_wp_array = [_this, 0] call BIS_fnc_param;
_mtradius = [_this, 1] call BIS_fnc_param;
_trg_center = [_this, 2] call BIS_fnc_param;

sleep 3.120;

_mtmhandle = _wp_array execVM "x_shc\x_getmtmission.sqf";

waitUntil {sleep 0.321;scriptDone _mtmhandle};

sleep 5.0123;

_posarx = _trg_center;
__getPos;
_vehicle = createVehicle [d_illum_tower, _poss, [], 0, "NONE"];
_vehicle setPos _poss;
_vehicle setVectorUp [0,0,1];
[_vehicle] call d_fnc_CheckMTHardTarget;
d_mt_radio_down = false;
["d_sSetVar", ["d_mt_radio_down", false]] call d_fnc_NetCallEventCTS;
["d_c_m_g", ["d_main_target_radiotower", _poss,"ICON","ColorBlack",[0.5,0.5],localize "STR_DOM_MISSIONSTRING_521",0,"mil_dot"]] call d_fnc_NetCallEventCTS;

["d_kbmsg", [9]] call d_fnc_NetCallEventCTS;
sleep 1.0112;
__specops;

sleep 5.234;
_dummy = d_target_names select d_current_target_index;
_cur_tgt_pos = _dummy select 0;
_cur_tgt_radius = _dummy select 2;
_act2 = d_enemy_side_trigger + " D";
d_mt_spotted = false;
d_create_new_paras = false;
d_f_check_trigger = [_cur_tgt_pos, [_cur_tgt_radius + 300, _cur_tgt_radius + 300, 0, false], [d_own_side_trigger, _act2, false], ["this", "0 = 0 spawn {if (!d_create_new_paras) then {d_create_new_paras = true;0 execFSM 'fsms\Parahandler.fsm'};d_mt_spotted = true;['d_kbmsg', [12]] call d_fnc_NetCallEventCTS;sleep 5;deleteVehicle d_f_check_trigger}", ""]] call d_fnc_CreateTrigger;

sleep 5.234;
_d_currentcamps = [];
_nrcamps = (ceil random 5) max 3;
_ctype = d_wcamp;

d_sum_camps = _nrcamps;
if (!isServer) then {
	["d_sSetVar", ["d_sum_camps", _nrcamps]] call d_fnc_NetCallEventCTS;
};
_posarx = _trg_center;
for "_i" from 1 to _nrcamps do {
	__getPos;
	_wf = createVehicle [_ctype, _poss, [], 0, "NONE"];
	_wf setDir floor random 360;
	_svec = sizeOf _ctype;
	_xcountx = 0;
	_isFlat = [];
	while {_xcountx < 99} do {
		_isFlat = (getPosATL _wf) isFlatEmpty [_svec / 2, 100, 0.7, _svec, 0, false, _wf];
		if !(_isFlat isEqualTo []) then {
			_isFlat set [2, 0];
			if (!isOnRoad _isFlat) then {
				_poss = _isFlat;
			} else {
				_isFlat = [];
			};
			if (!(_isFlat isEqualTo []) && {!(_d_currentcamps isEqualTo [])}) then {
				{
					if (_wf distance _x < 50) exitWith {
						_isFlat = [];
					};
				} forEach _d_currentcamps;
			};
		};
		if !(_isFlat isEqualTo []) exitWith {};
		_xcountx = _xcountx + 1;
	};
	_poss set [2, 0];
	_wf setPos _poss;
	_d_currentcamps pushBack _wf;
	_wf setVariable ["d_SIDE", d_enemy_side, true];
	_wf setVariable ["d_INDEX", _i, true];
	_wf setVariable ["d_CAPTIME", 40 + (floor random 10), true];
	_wf setVariable ["d_CURCAPTIME", 0, true];
	_wf setVariable ["d_CURCAPTURER", d_own_side_trigger_alt];
	_wf setVariable ["d_STALL", false, true];
	_wf setVariable ["d_TARGET_MID_POS", _trg_center];
	_fwfpos = getPosATL _wf;
	_fwfpos set [2, 4.3];
	_flagPole = createVehicle [d_flag_pole, _fwfpos, [], 0, "NONE"];
	_flagPole setPos _fwfpos;
	_wf setVariable ["d_FLAG", _flagPole, true];
	_maname = format["d_camp%1",_i];
	["d_c_m_g", [_maname, _poss,"ICON","ColorBlack",[0.5,0.5],"",0,d_strongpointmarker]] call d_fnc_NetCallEventCTS;
	_flagPole setFlagTexture (call d_fnc_getenemyflagtex);
	
	_wf addEventHandler ["HandleDamage", {0}];
	[_wf, _flagPole] execFSM "fsms\HandleCamps2.fsm";
	sleep 0.5;
};

["d_sSetVar", ["d_currentcamps", _d_currentcamps]] call d_fnc_NetCallEventCTS;
d_numcamps = count d_currentcamps; publicVariable "d_numcamps";
d_campscaptured = 0; publicVariable "d_campscaptured";

["d_kbmsg", [15, _nrcamps]] call d_fnc_NetCallEventCTS;

if (random 100 > 70) then {
	[_mtradius, _trg_center] call d_fnc_minefield;
};

sleep 5.213;
d_main_target_ready = true;
if (!isServer) then {
	["d_sSetVar", ["d_main_target_ready", true]] call d_fnc_NetCallEventCTS;
};
