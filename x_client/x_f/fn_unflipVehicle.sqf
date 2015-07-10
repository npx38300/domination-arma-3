#define THIS_FILE "fn_unflipVehicle.sqf"
#include "x_setup.sqf"
private ["_hhe","_vec"];
player removeAction (_this select 2);
_vec = (_this select 3) select 0;
_hhe = createVehicle [d_HeliHEmpty, getPosATL _vec, [], 0, "NONE"];
_vec setPos (getPosATL _hhe);
deleteVehicle _hhe;
