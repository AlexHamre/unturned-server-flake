{
  lib,
  stdenv,
  fetchSteam,
}:
stdenv.mkDerivation rec {
  name = "unturned-server";
  version = "3.24.7.1";
  src = fetchSteam {
    inherit name;
    appId = "1110390";
    depotId = "1110392";
    manifestId = "3114215424494400556";
    hash = "sha256-mzQm21J1p318Bq7Mhfp5VlqxaEFejM1SA3HOwlYUfSA=";
  };

  # Skip phases that don't apply to prebuilt binaries.
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

installPhase = ''
  runHook preInstall

  # Create the main directory
  mkdir -p $out

  # Copy the necessary subdirectories
  cp -r \
    BattlEye \
    Bundles \
    Cloud \
    Content \
    CuratedMapIcons \
    Examples \
    Extras \
    linux64 \
    LoadingScreens \
    Localization \
    Maps \
    Modules \
    Sandbox \
    Servers \
    steamapps \
    $out

  # Copy executable files
  cp -r \
    ExampleServer.sh \
    install.vdf \
    ServerHelper.sh \
    steamclient.so \
    UnityPlayer.so \
    Unturned_Headless.x86_64 \
    $out

  # Set permissions on the main executable
  chmod +x $out/Unturned_Headless.x86_64
  chmod +x $out/ExampleServer.sh
  chmod +x $out/ServerHelper.sh

  # Ensure the appropriate directory permissions
  chmod -R 755 $out

  runHook postInstall
'';


  meta = with lib; {
    description = "Unturned dedicated server";
    homepage = "https://steamdb.info/app/1110390/";
    changelog = "https://store.steampowered.com/news/app/1110390?updates=true";
    sourceProvenance = with sourceTypes; [binaryBytecode binaryNativeCode];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
  };
}