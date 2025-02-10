{
  lib,
  stdenv,
  fetchSteam,
  symlinkJoin,
}:

let
  baseDepot = fetchSteam {
    name = "unturned-server-base";
    appId = "1110390";
    depotId = "1110392";
    manifestId = "3114215424494400556";
    hash = "sha256-mzQm21J1p318Bq7Mhfp5VlqxaEFejM1SA3HOwlYUfSA=";
  };

  extraDepot = fetchSteam {
    name = "unturned-server-extra";
    appId = "1110390";
    depotId = "1110393"; # Replace with the correct depot ID
    manifestId = "3381894269381868866"; # Replace with the correct manifest ID
    hash = "sha256-HJpRCQDr6ss+Zi6PdXaic6bZzmjfHAgN652CKbBLMfM="; # Replace with the correct hash
  };

  mergedDepots = symlinkJoin {
    name = "unturned-server-merged";
    paths = [ baseDepot extraDepot ];
  };

in stdenv.mkDerivation {
  name = "unturned-server";
  version = "3.24.7.1";
  src = mergedDepots;

  # Skip phases that don't apply to prebuilt binaries.
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/* $TMPDIR/unturned-server

    # Ensure files are writable before modifying
    chmod -R u+w $TMPDIR/unturned-server

    cp -r $TMPDIR/unturned-server/* $out

    # Fix permissions on the main executable
    chmod +x $out/Unturned_Headless.x86_64

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
