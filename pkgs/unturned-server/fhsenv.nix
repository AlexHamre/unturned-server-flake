{
  lib,
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
  steam-run,
}:
buildFHSUserEnv {
  name = "unturned-server";

  targetPkgs = pkgs: with pkgs; [
    unturned-server-unwrapped
    steamworks-sdk-redist
  ];

  runScript = ''steam-run ./Unturned_Headless.x86_64 -batchmode -nographics +LanServer/MyServer'';

  inherit (unturned-server-unwrapped) meta;
}
