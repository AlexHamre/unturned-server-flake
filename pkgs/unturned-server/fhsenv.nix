{
  lib,
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
  pkgs,  # Ensure pkgs is available
}:
buildFHSUserEnv {
  name = "unturned-server";

  targetPkgs = pkgs: with pkgs; [
    steam-run-native  # Corrected from steamPackages.steam-run
    unturned-server-unwrapped
    steamworks-sdk-redist
  ];

  runScript = ''${pkgs.steam-run-native}/bin/steam-run ./Unturned_Headless.x86_64 -batchmode -nographics +LanServer/MyServer'';

  inherit (unturned-server-unwrapped) meta;
}
