// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_xmarkervehicles.sqf"
#include "x_setup.sqf"

if (isDedicated || {!isNil "d_is_sat_on"}) exitWith {};

private "_rem";
_rem = [];
{
	if (!isNull _x) then {
		_m = _x getVariable "d_marker";
		if (alive _x) then {
			_m setMarkerPosLocal (getPosASL _x);
			_m setMarkerDirLocal (getDir _x);
			_crw = crew _x;
			_numc = {alive _x} count _crw;
			if (_numc > 0 && {_numc != _x getVariable ["d_ma_cc", -1]}) then {
				_x setVariable ["d_ma_cc", _numc];
				_m setMarkerTypeLocal "mil_triangle";
				_nt = (_x getVariable "d_ma_text") + ": ";
				_cttt = count _crw - 1;
				{
					if (alive _x) then {
						_nt = _nt + (name _x);
						if (_forEachIndex < _cttt) then {
							_nt = _nt + ", ";
						};
					};
				} forEach _crw;
				__TRACE_1("","_nt")
				_m setMarkerTextLocal _nt;
			} else {
				if (_numc <= 0) then {
					_x setVariable ["d_ma_cc", -1];
					_mtt = _x getVariable "d_ma_type";
					if (markerType _m != _mtt) then {
						_m setMarkerTypeLocal _mtt;
						_m setMarkerTextLocal (_x getVariable "d_ma_text");
					};
				};
			};
			_m setMarkerAlphaLocal (if (!canMove _x) then {0.8} else {1.0});
		} else {
			_mtt = _x getVariable "d_ma_type";
			#ifdef __DEBUG__
			_mtm = markerType _m;
			__TRACE_2("","_mtt","_mtm")
			#endif
			if (markerType _m != _mtt) then {
				_m setMarkerPosLocal (getPosASL _x);
				_m setMarkerDirLocal (getDir _x);
				_m setMarkerTypeLocal _mtt;
				_m setMarkerTextLocal (_x getVariable "d_ma_text");
			};
			_rem pushBack _x;
		};
	};
} forEach d_marker_vecs;
if !(_rem isEqualTo []) then {
	__TRACE_1("","_rem")
	d_marker_vecs = d_marker_vecs - _rem;
	d_marker_vecs = d_marker_vecs - [objNull];
};