// by Xeno
#define THIS_FILE "fn_markercheck.sqf"
#include "x_setup.sqf"
private ["_val", "_pvar_name", "_body"];
if (!isServer) exitWith {};

_pvar_name = _this;

_val = d_placed_objs_store getVariable _pvar_name;
if (!isNil "_val") then {
	{
		deleteMarker (_x select 1);
		if (!isNull (_x select 0)) then {
			_content = (_x select 0) getVariable ["d_objcont", []];			
			if !(_content isEqualTo []) then {
				{
					deleteVehicle _x;
				} forEach _content;
			};
			
			if ((_x select 0) isKindOf d_mash) then {
				_cof = count d_mashes;
				d_mashes = d_mashes - [_x select 0];
				if (_cof != count d_mashes) then {
					publicVariable "d_mashes";
				};
			} else {
				if ((_x select 0) isKindOf (d_farp_classes select 0)) then {					
					_cof = count d_farps;
					d_farps = d_farps - [_x select 0];
					if (_cof != count d_farps) then {
						publicVariable "d_farps";
					};
				};
			};
			deleteVehicle (_x select 0);
		};
	} forEach _val;
	d_placed_objs_store setVariable [_pvar_name, nil];
};

if (isSteamMission) exitWith {endMission "LOSER"};
_val = d_placed_objs_store2 getVariable _pvar_name;
if (!isNil "_val") then {
	{
		if (!isNull _x) then {
			if (getNumber(configFile/"CfgVehicles"/typeOf _x/"isUav") == 1) then {
				{deleteVehicle _x} forEach [_x] + (crew _x);
			} else {
				deleteVehicle _x
			};
		};
	} forEach _val;
	d_placed_objs_store2 setVariable [_pvar_name, nil];
};

_body = missionNamespace getVariable _pvar_name;
if (!isNil "_body" && {!isNull _body}) then {deleteVehicle _body};