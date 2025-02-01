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
    # Fetch a different branch. <https://partner.steamgames.com/doc/store/application/branches>
    # branch = "beta_name";
    # Enable debug logging from DepotDownloader.
    # debug = true;
    # Only download specific files
    # fileList = ["filename" "regex:(or|a|regex)"];
    hash = "sha256-mzQm21J1p318Bq7Mhfp5VlqxaEFejM1SA3HOwlYUfSA=";
  };

  # Skip phases that don't apply to prebuilt binaries.
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r \
      *.so \
      *.debug \
      Unturned_Headless.x86_64 \
      Unturned_Headless_Data \
      $out

    # You may need to fix permissions on the main executable.
    chmod +x $out/Unturned_Headless.x86_64

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unturned dedicated server";
    homepage = "https://steamdb.info/app/1110390/";
    changelog = "https://store.steampowered.com/news/app/1110390?updates=true";
    sourceProvenance = with sourceTypes; [
      binaryNativeCode # Steam games are always going to contain some native binary component.
      binaryBytecode # e.g. Unity games using C#
    ];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
  };
}