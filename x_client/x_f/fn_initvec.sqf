// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_initvec.sqf"
#include "x_setup.sqf"
#define __vecmarker _mxname = _car select 2; \
if (markerType _mxname == "") then { \
[_mxname, getPosASL _vec,"ICON",_car select 4,[1,1],_mt,0,_car select 3] call d_fnc_CreateMarkerLocal;\
} else { \
_mxname setMarkerPosLocal (visiblePositionASL _vec); \
_mxname setMarkerTypeLocal (_car select 3); \
_mxname setMarkerTextLocal _mt; \
}; \
_vec setVariable ["d_marker", _mxname];\
_vec setVariable ["d_ma_cc", -1];\
_vec setVariable ["d_ma_text", _car select 5]; \
_vec setVariable ["d_ma_type", _car select 3]; \
d_marker_vecs pushBack _vec;

#define __chopmarker _mxname = _car select 2; \
if (markerType _mxname == "") then { \
[_mxname, getPosASL _vec,"ICON",_car select 5,[1,1],_car select 6,0,_car select 4] call d_fnc_CreateMarkerLocal;\
} else { \
_mxname setMarkerPosLocal (visiblePositionASL _vec); \
_mxname setMarkerTypeLocal (_car select 4); \
_mxname setMarkerTextLocal (_car select 6); \
}; \
_vec setVariable ["d_marker", _mxname];\
_vec setVariable ["d_ma_cc", -1];\
_vec setVariable ["d_ma_text", _car select 6]; \
_vec setVariable ["d_ma_type", _car select 4]; \
d_marker_vecs pushBack _vec;\
if (count _car > 8) then {_vec setVariable ["d_lift_types", _car select 8]}

#define __chopset _index = _car select 1;\
_vec setVariable ["d_choppertype", _index];\
_vec setVariable ["d_vec_type", "chopper"];\
switch (_index) do {\
	case 0: {_vec addEventHandler ["getin", {[_this,0] call d_fnc_checkhelipilot}]};\
	case 1: {_vec addEventHandler ["getin", {_this call d_fnc_checkhelipilot_wreck}]};\
	case 2: {_vec addEventHandler ["getin", {[_this,1] call d_fnc_checkhelipilot}]};\
};\
_vec addEventHandler ["getout", {_this call d_fnc_checkhelipilotout}]

#define __vecname _vec setVariable ["d_vec_name", _car select 6]
#define __chopname _vec setVariable ["d_vec_name", _car select 7]
#define __pvecs {if ((_x select 1) == _d_vec) exitWith {_car = _x}} forEach d_p_vecs

#define __staticl \
_vec addAction[(localize "STR_DOM_MISSIONSTRING_256") call d_fnc_GreyText,{_this spawn d_fnc_load_static},_d_vec,-1,false,true,"","count (_target getVariable ['d_CARGO_AR', []]) < d_max_truck_cargo"];\
_vec addAction[(localize "STR_DOM_MISSIONSTRING_257") call d_fnc_RedText,{_this spawn d_fnc_unload_static},_d_vec,-2,false,true,"","vehicle player == player && {!((_target getVariable ['d_CARGO_AR', []]) isEqualTo [])}"]

#define __addchopm _vec addAction [(localize "STR_DOM_MISSIONSTRING_258") call d_fnc_GreyText, {_this call d_fnc_vecdialog},[],-1,false]
#define __halo _vec addAction [(localize "STR_DOM_MISSIONSTRING_259") call d_fnc_GreyText, {_this call d_fnc_chalo},[],-1,false,true,"","vehicle player != player && {((vehicle player) call d_fnc_GetHeight) > 50}"]

#define __chopdoors \
_dooranims = []; \
{ \
	_dooranims pushBack (configName _x); \
} forEach ("getText (_x/'source') == 'door'" configClasses (configFile/"CfgVehicles"/(typeOf _vec)/"AnimationSources")); \
if !(_dooranims isEqualTo []) then { \
	_vec addAction ["<t color='#CFCFCF'>" + (localize "STR_DOM_MISSIONSTRING_1507") + "</t>", {_this call d_fnc_chopperdoors},[1, _dooranims] ,6,false,true,"", format ["alive _target && {_target animationPhase '%1' == 0}", _dooranims select 0]]; \
	_vec addAction ["<t color='#CFCFCF'>" + (localize "STR_DOM_MISSIONSTRING_1508") + "</t>", {_this call d_fnc_chopperdoors}, [0, _dooranims],6,false,true,"", format ["alive _target && {_target animationPhase '%1' == 1}", _dooranims select 0]]; \
}

if (isDedicated) exitWith {};

private "_vec";

_vec = _this;

__TRACE_1("","_vec")

private "_desm";
_desm = _vec getVariable ["d_deserted_marker", ""];
if (_desm != "") then {
	[_desm, getPosASL _vec,"ICON","ColorBlack",[1,1], format [localize "STR_DOM_MISSIONSTRING_260", [typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName],0,"hd_dot"] call d_fnc_CreateMarkerLocal;
};

_d_vec = _vec getVariable "d_vec";
if (isNil "_d_vec") exitWith {};

if (!isNil {_vec getVariable "d_vcheck"}) exitWith {};
_vec setVariable ["d_vcheck", true];

if (_d_vec < 100) exitWith {
	_car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		_mt = _car select 5;
		if (_vec getVariable ["d_MHQ_Deployed", false]) then {
			_mt = format [localize "STR_DOM_MISSIONSTRING_261", _mt];
		};
		if (markerType (_car select 2) != "") then {
			(_car select 2) setMarkerTextLocal _mt;
		};
		__vecmarker;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec addAction [(localize "STR_DOM_MISSIONSTRING_262") call d_fnc_GreyText, {_this call d_fnc_vecdialog},_d_vec,-1,false];
	_vec addAction ["<t color='#FF0000'>Heal</t>", "Heal_Action.sqf", [], 6, true, true, "", "vehicle _this == _this && _this distance getPos _target < 4 && getDammage player > 0"];
	_vec setVariable ["d_vec_type", "MHQ"];
	_vec setAmmoCargo 0;
};

if (_d_vec < 200) exitWith {
	_car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		_mt = _car select 5;
		__vecmarker;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
};

if (_d_vec < 300) exitWith {
	_car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		_mt = _car select 5;
		__vecmarker;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
};

if (_d_vec < 400) exitWith {
	_car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		_mt = _car select 5;
		__vecmarker;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	if (d_with_ai || {d_with_ai_features == 0} || {d_string_player in d_is_engineer}) then {
		__staticl;
	} else {
		_vec addEventHandler ["getin", {_this call d_fnc_checktrucktrans}];
	};
	_vec setVariable ["d_vec_type", "Engineer"];
	_vec setAmmoCargo 0;
};

if (_d_vec < 500) exitWith {
	_car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		_mt = _car select 5;
		__vecmarker;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
};

if (_d_vec < 4000) exitWith {
	_car = [];
	{if ((_x select 3) == _d_vec) exitWith {_car = _x}} forEach d_choppers;
	__TRACE_1("","_car")
	if !(_car isEqualTo []) then {
		if (!alive _vec) exitWith {};
		missionNamespace setVariable [_car select 0, _vec];
		__chopname;
		__chopmarker;
	};
	if (!alive _vec) exitWith {};
	__addchopm;
	__chopset;
	__halo;
	__chopdoors;
};
