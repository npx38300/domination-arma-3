//#define __DEBUG__
// by Xeno
#define THIS_FILE "fn_dosshowhuddo2spawn.sqf"
#include "x_setup.sqf"

waitUntil {time >= d_pnhuddo2_endtime};
d_showPlayerNameRSC_shown = false;
4769 cutRsc ["d_Empty", "PLAIN"];