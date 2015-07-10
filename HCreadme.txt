How to run a headless client (HC) on your server...

First of all, add a text file named
steam_appid.txt
to your arma3 folder on your server (if it doesn't exist).

Add the following text to steam_appid.txt:
107410

Now you are able to run more than one A3 instance.

Next add the following to your server.cfg:
localClient[]={127.0.0.1};

Start the headless client like this:
CMD /C START arma3.exe -client -localhost=127.0.0.1 -name=Klaus-Baerbel -nosound -noFilePatching -password=1234 -profiles=d:\hcprofiles
(-password is not needed if you do not have a password, but always use an extra profiles folder)

That's basically it.

Please note that for performance reasons you have to setup a HC in a similar way like your server. Apply the same (A3 server) network settings to the HC.

Note: I have no idea if HC support still works as it is not possible for a mission maker to test it locally in LAN mode
(as stupid as it sounds... you can connect with multiple normal local graphical clients to a local dedicated server in LAN mode but not with a local headless client)