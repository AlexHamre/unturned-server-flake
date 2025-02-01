{
  lib,
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
  pkgs,  # Add pkgs as an argument
}:
buildFHSUserEnv {
  name = "unturned-server";

  targetPkgs = pkgs: with pkgs; [
    steamPackages.steam-run  # Ensure steam-run is available
    unturned-server-unwrapped
    steamworks-sdk-redist
  ];

  runScript = ''${pkgs.steamPackages.steam-run}/bin/steam-run ./Unturned_Headless.x86_64 -batchmode -nographics +LanServer/MyServer'';

  inherit (unturned-server-unwrapped) meta;
}
