// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makemtgmarker.sqf"
#include "x_setup.sqf"

_dd = d_target_names select d_current_target_index;
_cur_tar_rad = _dd select 2;
["d_c_m_g", ["d_" + (_dd select 1) + "_dommtm", _dd select 0, "ELLIPSE", d_e_marker_color, [_cur_tar_rad, _cur_tar_rad]]] call d_fnc_NetCallEventCTS;
