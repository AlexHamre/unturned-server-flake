{
  buildFHSUserEnv,
  writeScript,
  unturned-server-unwrapped,
  steamworks-sdk-redist,
  zlib,
  pulseaudio,
}:
buildFHSUserEnv {
  name = "unturned-server";

  runScript = writeScript "unturned-server-wrapper" ''
    export LD_LIBRARY_PATH=${steamworks-sdk-redist}/lib:$LD_LIBRARY_PATH
    export SteamAppId=892970
    exec ${unturned-server-unwrapped}/Unturned_Headless.x86_64 -batchmode -nographics +LanServer/MyServer "$@"
  '';

  targetPkgs = pkgs: [
    unturned-server-unwrapped
    steamworks-sdk-redist
    zlib
    pulseaudio
  ];

  inherit (unturned-server-unwrapped) meta;
}
