//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_getrankfromscore.sqf"
#include "x_setup.sqf"

if (_this < (d_points_needed select 0)) exitWith {"Private"};
if (_this < (d_points_needed select 1)) exitWith {"Corporal"};
if (_this < (d_points_needed select 2)) exitWith {"Sergeant"};
if (_this < (d_points_needed select 3)) exitWith {"Lieutenant"};
if (_this < (d_points_needed select 4)) exitWith {"Captain"};
if (_this < (d_points_needed select 5)) then {"Major"} else {"Colonel"};