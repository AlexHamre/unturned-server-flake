{
  lib,
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
}:
buildFHSUserEnv {
  name = "unturned-server";

  runScript = "/Unturned_Headless.x86_64 -batchmode -nographics +LanServer/MyServer";

  targetPkgs = pkgs: [
    unturned-server-unwrapped
    steamworks-sdk-redist
  ];

  inherit (unturned-server-unwrapped) meta;
}