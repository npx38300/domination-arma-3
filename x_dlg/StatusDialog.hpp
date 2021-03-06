#include "x_setup.sqf"
class D_StatusDialog {
	idd = -1;
	movingEnable = 1;
	onLoad = "uiNamespace setVariable ['D_StatusDialog', _this select 0];[_this select 0] call bis_fnc_guiEffectTiles;d_showstatus_dialog_open = true;d_do_ma_update_n = true";
	onUnLoad = "uiNamespace setVariable ['D_StatusDialog', nil];d_showstatus_dialog_open = false;d_do_ma_update_n = false";
	effectTilesAlpha = 0.15;
	class controlsBackground {
		COMMON_BACKGROUND_VIGNETTE
		COMMON_BACKGROUND_TILES
		__DDIALOG_BG($STR_DOM_MISSIONSTRING_1318)
	};
	class controls {
		class TeamStatusButton: RscButtonBase2 {
			idc = 11009;
			text = "$STR_DOM_MISSIONSTRING_1301";
			action = "closeDialog 0;createDialog 'D_SquadManagementDialog'";
			x = 0.68;
			y = 0.62;
		};
		class SettingsButton: RscButtonBase2 {
			text = "$STR_DOM_MISSIONSTRING_1302";
			action = "CloseDialog 0;call d_fnc_settingsdialog";
			x = 0.68;
			y = 0.67;
		};
		class FixHeadBugButton: RscButtonBase2 {
			text = "$STR_DOM_MISSIONSTRING_1303"; 
			action = "closeDialog 0;player spawn d_fnc_FixHeadBug";
			x = 0.68;
			y = 0.72;
		};
		class AdminButton: RscButtonBase2 {
			idc = 123123;
			text = "$STR_DOM_MISSIONSTRING_1305";
			action = "closeDialog 0;call d_fnc_admindialog";
			x = 0.68;
			y = 0.82;
		};
		__CANCELCLOSEB($STR_DOM_MISSIONSTRING_1218,-1)
		class ShowSideButton: RscLinkButtonBase {
			x = 0.03;
			y = 0.03;
			w = 0.15;
			h = 0.1;
			sizeEx = 0.031;
			text = "$STR_DOM_MISSIONSTRING_1306";
			action = "[0] call d_fnc_showsidemain_d";
			shadow = 0;
		};
		class ShowMainButton: RscLinkButtonBase {
			x = 0.68;
			y = 0.09;
			w = 0.125;
			h = 0.1;
			sizeEx = 0.032;
			text = "$STR_DOM_MISSIONSTRING_1307";
			action = "[1] call d_fnc_showsidemain_d";
			shadow = 0;
		};
		class SideMissionTxt: RscText2 {
			idc = 11002;
			style = ST_MULTI;
			sizeEx = 0.028;
			lineSpacing = 1;
			colorBackground[] = __GUI_BCG_RGB;
			x = 0.04;
			y = 0.1;
			w = 0.5;
			h = 0.15;
			text = "";
			shadow = 0;
		};
		class SecondaryCaption: RscText2 {
			x = 0.04;
			y = 0.225;
			w = 0.30;
			h = 0.1;
			sizeEx = 0.031;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = {1, 1, 1, 1};
			text = "$STR_DOM_MISSIONSTRING_1308";
			shadow = 0;
		};
		class SecondaryTxt: SideMissionTxt {
			idc = 11007;
			y = 0.3;
			h = 0.07;
		};
		class IntelCaption: SecondaryCaption {
			idc = 11019;
			y = 0.34;
			text = "$STR_DOM_MISSIONSTRING_1309";
		};
		class IntelTxt: SideMissionTxt {
			idc = 11018;
			y = 0.41;
			h = 0.07;
		};
		class WeatherInfoCaption: SecondaryCaption {
			y = 0.45;
			w = 0.45;
			text = "$STR_DOM_MISSIONSTRING_1310";
		};
		class WeatherInfo: SideMissionTxt {
			idc = 11013;
			y = 0.52;
			h = 0.04;
		};
		class MainTargetNumber: RscText2 {
			idc = 11006;
			x = 0.81;
			y = 0.09;
			w = 0.25;
			h = 0.1;
			sizeEx = 0.032;
			colorText[] = __GUI_TXT_RGB;
			colorBackground[] = {1, 1, 1, 0};
			text = "";
			shadow = 0;
		};
		class MainTarget: RscText2 {
			idc = 11003;
			x = 0.68;
			y = 0.15;
			w = 0.25;
			h = 0.1;
			sizeEx = 0.032;
			colorText[] = __GUI_TXT_RGB;
			colorBackground[] = {1, 1, 1, 0};
			text = "";
			shadow = 0;
		};
		class Map: D_RscMapControl {
			idc = 11010;
			colorBackground[] = {0.9, 0.9, 0.9, 0.9};
			x = 0.04;
			y = 0.58;
			w = 0.5;
			h = 0.33;
			showCountourInterval = false;
		};
		class HintCaption: RscText2 {
			idc = -1;
			x = 0.35;
			y = 0.005;
			w = 0.63;
			h = 0.03;
			sizeEx = 0.03;
			shadow = 1;
			colorBackground[] = {0, 0, 0, 0};
			text = "$STR_DOM_MISSIONSTRING_1313";
		};
		class RankCaption: RscText2 {
			x = 0.68;
			y = 0.34;
			w = 0.25;
			h = 0.1;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = {1, 1, 1, 1};
			sizeEx = 0.032;
			text = "$STR_DOM_MISSIONSTRING_1314";
			shadow = 0;
		};
		class RankPicture: D_RscPicture {
			idc = 12010;
			x=0.69; y=0.415; w=0.02; h=0.025;
			text="";
			sizeEx = 256;
			colorText[] = {1, 1, 1, 1};
		};
		class RankString: RscText2 {
			idc = 11014;
			x = 0.72;
			y = 0.378;
			w = 0.25;
			h = 0.1;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = __GUI_TXT_RGB;
			sizeEx = 0.032;
			text = "";
			shadow = 0;
		};
		class ScoreCaption: RankCaption {
			y = 0.42;
			text = "$STR_DOM_MISSIONSTRING_1315";
		};
		class ScoreP: RscText2 {
			idc = 11233;
			x = 0.79;
			y = 0.42;
			w = 0.25;
			h = 0.1;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = __GUI_TXT_RGB;
			sizeEx = 0.032;
			text = "0";
			shadow = 0;
		};
		class CampsCaption: RscText2 {
			x = 0.68;
			y = 0.465;
			w = 0.25;
			h = 0.1;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = {1, 1, 1, 1};
			sizeEx = 0.032;
			text = "$STR_DOM_MISSIONSTRING_1316";
			shadow = 0;
		};
		class CampsNumber: RscText2 {
			idc = 11278;
			x = 0.834;
			y = 0.465;
			w = 0.25;
			h = 0.1;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = __GUI_TXT_RGB;
			sizeEx = 0.032;
			text = "";
			shadow = 0;
		};
		class RLivesCaption: RscText2 {
			idc = 30000;
			x = 0.68;
			y = 0.51;
			w = 0.25;
			h = 0.1;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = {1, 1, 1, 1};
			sizeEx = 0.032;
			text = "$STR_DOM_MISSIONSTRING_1317";
			shadow = 0;
		};
		class RLivesNumber: RscText2 {
			idc = 30001;
			x = 0.79;
			y = 0.51;
			w = 0.25;
			h = 0.1;
			colorBackground[] = {1, 1, 1, 0};
			colorText[] = __GUI_TXT_RGB;
			sizeEx = 0.032;
			text = "0";
			shadow = 0;
		};		
	};
};
