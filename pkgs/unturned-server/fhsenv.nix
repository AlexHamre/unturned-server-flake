{
  lib,
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
  pkgs,  
}:
buildFHSUserEnv {
  name = "unturned-server";

  targetPkgs = pkgs: with pkgs; [
    steam-run 
    unturned-server-unwrapped
    steamworks-sdk-redist
  ];

  runScript = ''steam-run ./Unturned_Headless.x86_64 -batchmode -nographics +LanServer/MyServer'';

  inherit (unturned-server-unwrapped) meta;
}
