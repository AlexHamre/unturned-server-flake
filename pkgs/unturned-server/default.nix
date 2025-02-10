{
  lib,
  stdenv,
  fetchSteam,
  symlinkJoin,
}:

let
  baseDepot = fetchSteam {
    name = "unturned-server";
    appId = "1110390";
    depotId = "1110392";
    manifestId = "3114215424494400556";
    hash = "sha256-mzQm21J1p318Bq7Mhfp5VlqxaEFejM1SA3HOwlYUfSA=";
  };

  extraDepot = fetchSteam {
    name = "unturned-server";
    appId = "1110390";
    depotId = "1110393"; # Replace with the correct depot ID
    manifestId = "3381894269381868866"; # Replace with the correct manifest ID
    hash = "sha256-HJpRCQDr6ss+Zi6PdXaic6bZzmjfHAgN652CKbBLMfM="; # Replace with the correct hash
  };

in symlinkJoin {
  name = "unturned-server";
  paths = [ baseDepot extraDepot ];

  # Skip phases that don't apply to prebuilt binaries.
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out

    # Workaround for permissions issue
    chmod +x $out/Unturned_Headless.x86_64 || true

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
