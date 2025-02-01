{
  lib,
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
}:
buildFHSUserEnv {
  name = "unturned-server";

  runScript = "unturned-server-executable";

  targetPkgs = pkgs: [
    unturned-server-unwrapped
    steamworks-sdk-redist
  ];

  inherit (unturned-server-unwrapped) meta;
}