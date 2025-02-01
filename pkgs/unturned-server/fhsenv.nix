{
  lib,
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
}:
buildFHSUserEnv {
  name = "unturned-server";

  runScript = "/ServerHelper.sh +LanServer/MyServer";

  targetPkgs = pkgs: [
    unturned-server-unwrapped
    steamworks-sdk-redist
  ];

  inherit (unturned-server-unwrapped) meta;
}