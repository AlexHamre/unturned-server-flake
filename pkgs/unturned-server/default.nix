{
  lib,
  stdenv,
  fetchSteam,
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
    depotId = "1110393";
    manifestId = "3381894269381868866";
    hash = "sha256-HJpRCQDr6ss+Zi6PdXaic6bZzmjfHAgN652CKbBLMfM=";
  };

  additionalDepot1 = fetchSteam {
    name = "unturned-server";
    appId = "1110390";
    depotId = "1110394"; # New depot ID
    manifestId = "3609612843127309127"; # New manifest ID
    hash = "sha256-<replace-with-correct-hash>"; # Add the correct hash for this depot
  };

  additionalDepot2 = fetchSteam {
    name = "unturned-server";
    appId = "90"; # New app ID
    depotId = "1006"; # New depot ID
    manifestId = "7138471031118904166"; # New manifest ID
    hash = "sha256-<replace-with-correct-hash>"; # Add the correct hash for this depot
  };

in stdenv.mkDerivation rec {
  name = "unturned-server";
  
  buildInputs = [ baseDepot extraDepot additionalDepot1 additionalDepot2 ];

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  src = baseDepot;
  srcs = [ extraDepot additionalDepot1 additionalDepot2 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # Copy files with --no-preserve=mode to avoid permission issues
    for dep in $src $srcs; do
      cp -r --no-preserve=mode $dep/* $out/
    done

    # Ensure the main executable is executable
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
