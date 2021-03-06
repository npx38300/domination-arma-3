#define addc(cname) class cname {headerType = -1;}
class cfgFunctions {
	version = 3.0;
	createShortcuts = 1;
	class Dom {
		tag = "d";
		class Dom_Client {
			file = "x_client\x_f";
			addc(greytext);
			addc(redtext);
			addc(bluetext);
			addc(playerspawn);
			addc(dlgopenx);
			addc(prespawned);
			addc(spawn_mash);
			addc(spawn_farp);
			addc(mousewheelrec);
			addc(domcommandingmenuexec);
			addc(createdomusermenu);
			addc(keydowncommandingmenu);
			addc(Keys);
			addc(chop_hudsp);
			addc(vec_hudsp);
			addc(playervectrans);
			addc(playerveccheck);
			addc(mhqcheckneartarget);
			addc(vehiclescripts);
			addc(startclientscripts);
			addc(chopper_welcome2);
			addc(vec_welcome_message);
			addc(removelinebreak);
			addc(hintchatmsg);
			addc(fixheadbug);
			addc(getranjumppoint);
			addc(handleheal);
			addc(extractmagvals);
			addc(getloadedmags);
			addc(save_respawngear);
			addc(retrieve_respawngear);
			addc(retrieve_layoutgear);
			addc(ispilotcheck);
			addc(filldropedbox);
			addc(create_boxnet);
			addc(ataxinet);
			addc(player_stuff);
			addc(dropansw);
			addc(mhqdeplnet);
			addc(intel_updnet);
			addc(sfunc);
			addc(ffunc);
			addc(placedobjan);
			addc(recapturedupdate);
			addc(playerrank);
			addc(getrankindex);
			addc(getrankindex2);
			addc(getrankstring);
			addc(getrankfromscore);
			addc(getrankpic);
			addc(baseenemies);
			addc(progbarcall);
			addc(playerfiredeh);
			addc(xmarkervehicles);
			addc(xmarkerplayers);
			addc(xai_markers);
			addc(showstatus);
			addc(settingsdialog);
			addc(dropammoboxdx);
			addc(loaddroppedx);
			addc(deploy_mhq);
			addc(teleportx);
			addc(beam_tele);
			addc(checktrucktrans);
			addc(checkhelipilot);
			addc(checkhelipilot_wreck);
			addc(checkhelipilotout);
			addc(initvec);
			addc(lockc);
			addc(save_layoutgear);
			addc(artillery);
			addc(calldrop);
			addc(sethud);
			addc(vecdialog);
			addc(chalo);
			addc(heli_action);
			addc(heli_release);
			addc(bike);
			addc(recruitaiaction);
			addc(restoreeng);
			addc(searchbody);
			addc(flipatv);
			addc(repanalyze);
			addc(repengineer);
			addc(backpack);
			addc(nostreaming);
			addc(newflagclient);
			addc(helilift);
			addc(helilift_wreck);
			addc(createnexttargetclient);
			addc(target_clear_client);
			addc(deleteplayermarker);
			addc(moveai);
			addc(airtaxi);
			addc(makeuav);
			addc(haschemlight);
			addc(attachchemlight);
			addc(detachchemlight);
			addc(chopperdoors);
			addc(load_static);
			addc(unload_static);
			addc(paraj);
			addc(pjump);
			addc(getoutehpoints);
			addc(satellitedo);
			addc(unflipVehicle);
			addc(weaponcargo);
			addc(weaponcargo_ranked);
			addc(ptakeweapon);
			addc(pputweapon);
			addc(store_rwitems);
			addc(healatmash);
			addc(mark_artillery);
			addc(dosshowhuddo2spawn);
			addc(player_name_huddo2);
			addc(player_name_huddo);
			addc(inventoryopened);
			addc(command_menu);
		};
		class Dom_UI {
			file = "x_client\x_f\x_ui";
			addc(initartydlg2);
			addc(initMarkArtyDlg);
			addc(artytypeselchanged2);
			addc(firearty);
			addc(firearty2);
			addc(glselchanged);
			addc(pmselchanged);
			addc(showsidemain_d);
			addc(admindialog);
			addc(adselchanged);
			addc(vdsliderchanged);
			addc(adminspectate);
			addc(fillunload);
			addc(unloadsetcargo);
			addc(create_vecx);
			addc(fillrecruit);
			addc(recruitbuttonaction);
			addc(dismissbuttonaction);
			addc(dismissallbuttonaction);
			addc(squadmanagementfill);
			addc(squadmgmtlockbuttonclicked);
			addc(squadmgmtbuttonclicked);
			addc(squadmgmtlbchanged);
			addc(squadmgmtlblostfocus);
			addc(cam_rose);
			addc(removeallusermarkers);
			addc(removediscusermarkers);
			addc(updatesupportrsc);
			addc(artmselchanged);
			addc(initvecdialog);
			addc(initairdropdialog);
			addc(pnselchanged);
			addc(teleportdialoginit);
			addc(update_telerespsel);
			addc(teleupdate_dlg);
			addc(scacheck);
			addc(scexec);
		};
		class Dom_Common_Net {
			file = "x_common\x_f\x_net";
			addc(netaddevent);
			addc(netaddeventcts);
			addc(netaddeventsto);
			addc(netaddeventtoclients);
			addc(netremoveevent);
			addc(netremoveeventcts);
			addc(netremoveeventsto);
			addc(netremoveeventservtoclients);
			addc(netrunevent);
			addc(netruneventcts);
			addc(netruneventsto);
			addc(netruneventtoclients);
			addc(netcallevent);
			addc(netcalleventcts);
			addc(netcalleventsto);
			addc(netcalleventtoclients);
		};
		class Dom_Common {
			file = "x_common\x_f";
			addc(mhqfunc);
			addc(checkshc);
			addc(removenvgoggles);
			addc(hasnvgoggles);
			addc(hastoolkit);
			addc(randomfloor);
			addc(randomarray);
			addc(randomindexarray);
			addc(getconfiggroup);
			addc(randomfloorarray);
			addc(randomarrayval);
			addc(playersnumber);
			addc(getrandomrangeint);
			addc(getheight);
			addc(setheight);
			addc(getdisplayname);
			addc(getslope);
			addc(createmarkerglobal);
			addc(createmarkerlocal);
			addc(getaliveunits);
			addc(getaliveunitsgrp);
			addc(getalivecrew);
			addc(getvehicleempty);
			addc(dirto);
			addc(createtrigger);
#ifdef __GROUPDEBUG__
			addc(linemaker2);
#endif
			addc(posbehind2);
			addc(getgroup);
			addc(sortar);
			addc(isveclocked);
			addc(worldboundscheck);
			addc(getranpointcircle);
			addc(getranpointcirclenoslope);
			addc(getranpointcircleold);
			addc(getranpointcirclebig);
			addc(getranpointcircleouter);
			addc(getranpointsquare);
			addc(getranpointouterair);
			addc(reload);
			addc(plcheckkill);
			addc(mpcheck);
			addc(getenemyflagtex);
			addc(removefak);
			addc(disdeadvec);
			addc(tjetservice);
			addc(tchopservice);
			addc(tvecservice);
			addc(arraypushstack);
		};
		class Dom_ext_Scripts {
			file = "scripts";
			addc(establishingShot);
		};
		class Dom_KBTell {
			file = "x_bikb";
			addc(kehflogic);
		};
		class Dom_SMMissions {
			file = "x_missions";
			addc(checksmshothd);
			addc(killedsmtargetnormal);
			addc(killedsmtarget500);
			addc(addkilledehsm);
			addc(getsidemissionclient);
			addc(sidemissionwinner);
			addc(getsidemission);
			addc(sidempkilled);
			addc(smmapos);
		};
		class Dom_SMMissions_Common {
			file = "x_missions\common";
			addc(sidearrest);
			addc(sidearti);
			addc(sideconvoy);
			addc(sideevac);
			addc(sidefactory);
			addc(sideflag);
			addc(sideprisoners);
			addc(sidespecops);
			addc(sidesteal);
			addc(sidetanks);
		};
		class Dom_Server {
			file = "x_server\x_f";
			addc(addkillsai);
			addc(getwreck);
			addc(placedobjkilled);
			addc(getplayerarray);
			addc(tkkickcheck);
			addc(kickplayerbs);
			addc(rptmsgbs);
			addc(admindeltks);
			addc(getadminarray);
			addc(changerlifes);
			addc(remabox);
			addc(createdroppedbox);
			addc(createmhqenemyteletrig);
			addc(removemhqenemyteletrig);
			addc(tkr);
			addc(fuelCheck);
			addc(dokbmsg);
			addc(createplayerbike);
			addc(vehirespawn);
			addc(vehirespawn2);
			addc(arifire);
			addc(markercheck);
			addc(wreckmarker2);
			addc(domend);
			addc(airtaxiserver);
			addc(createdrop);
			addc(getbonus);
			addc(createnexttarget);
			addc(target_clear);
			addc(createjumpflag);
			addc(gettargetbonus);
			addc(pshootatarti);
			addc(createrandomtargets);
			addc(supplydrop);
			addc(handledisconnect);
			addc(heli_local_check);
			addc(chopperkilled);
		};
		class Dom_SHC {
			file = "x_shc\x_f";
			addc(addtoclean);
			addc(shootari);
			addc(spawnvehicle);
			addc(spawncrew);
			addc(taskdefend);
			addc(makegroup);
			addc(createpara3x);
			addc(setgstate);
			addc(hcaddvec);
			addc(creategroup);
			addc(getwparray);
			addc(getwparray2);
			addc(getwparray3);
			addc(getunitlist);
			addc(getmixedlist);
			addc(handledeadvec);
			addc(makevgroup);
			addc(makemgroup);
			addc(createinf);
			addc(createarmor);
			addc(outofbounds);
			addc(makepatrolwpx);
			addc(makepatrolwpx2);
			addc(delvecandcrew);
			addc(guardwp);
			addc(attackwp);
			addc(selectcrew);
			addc(sidemissionresolved);
			addc(checkmtshothd);
			addc(checkmthardtarget);
			addc(getsmtargetmessage);
			addc(mtsmtargetkilled);
			addc(airmarkermove);
			addc(isledefmarkermove);
			addc(make_isle_grp);
			addc(counterattack);
			addc(createmaintarget);
			addc(docreatenexttarget);
			addc(dorecapture);
			addc(minefield);
			addc(createsecondary);
			addc(handleobservers);
			addc(handleattackgroups);
			addc(makemtgmarker);
		};
		class Dom_PrePostInit {
			file = "x_init";
			class preinit {
				preInit = 1;
				headerType = -1;
			};
			class postinit {
				postInit = 1;
				headerType = -1;
			};
		};
	};
	class Dom_Revive {
		tag = "xr";
		class Dom_Revivexr {
			file = "x_revive\xr_f";
			addc(handlenet);
			addc(killedeh);
			addc(respawneh);
			addc(checkrespawn);
			addc(addmarker);
			addc(closespectcontrols);
			addc(doslope);
			addc(dorevive);
			addc(buttonclickrespawn);
			addc(joingr);
			addc(waterfix);
			addc(targetsslbchange);
			addc(mousedownclickedloop);
			addc(dlgevents);
			addc(spectating);
			addc(spect_oneframe);
			addc(addactions);
			addc(removeactions);
			addc(park_player);
			addc(uncon);
			addc(uncon_oneframe);
			addc(clienthd);
			addc(dragkeydown);
			addc(drag);
			addc(dragprone);
			addc(cdorevive);
			addc(drop_body);
			addc(carry);
			addc(selfheal);
			addc(updaterlb);
			addc(showppos);
		};
	};
	#include "VAS\cfgfunctions.hpp"
};