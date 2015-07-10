//#define __DEBUG__
#define THIS_FILE "fn_sortar.sqf"
#include "x_setup.sqf"

/************************************************************
	Sort Numbers
	By Andrew Barron
	Modified by Xeno

Sorts an array of numbers from lowest (left) to highest (right).
The passed array is modified by reference.

This function uses the quick sort algorithm.
************************************************************/

private "_sort";
_sort = {
	private ["_h","_i","_j","_hi","_x"];
	_a = [_this, 0] call BIS_fnc_param;
	_id = [_this, 1] call BIS_fnc_param;
	_lo = [_this, 2] call BIS_fnc_param;
	_hi = [_this, 3] call BIS_fnc_param;
	 // _a, array to be sorted
	 // _id, array item index to be compared
	 // _lo, lower index to sort from
	 // _hi, upper index to sort to

	_h = nil; //used to make a do-while loop below
	_i = _lo;
	_j = _hi;
	if (_a isEqualTo []) exitWith {[]};
	_x = (_a select ((_lo + _hi) / 2)) select _id;

	//  partition
	while {isnil "_h" || {_i <= _j}} do {
		//find first and last elements within bound that are greater / lower than _x
		while {(_a select _i) select _id < _x} do {_i = _i + 1};
		while {(_a select _j) select _id > _x} do {_j = _j - 1};

		if (_i <= _j) then {
			//swap elements _i and _j
			_h = _a select _i;
			_a set [_i, _a select _j];
			_a set [_j, _h];

			_i = _i + 1;
			_j = _j - 1;
		};
	};

	// recursion
	if (_lo < _j) then {[_a, _id, _lo, _j] call _sort};
	if (_i < _hi) then {[_a, _id, _i, _hi] call _sort};
};

// and start it off
[_this select 0, _this select 1, 0, 0 max ((count (_this select 0)) - 1)] call _sort;

// array is already modified by reference, but return the modified array anyway
_this select 0