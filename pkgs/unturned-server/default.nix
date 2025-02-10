{ lib, stdenv, fetchSteam }:

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
    depotId = "1110393";
    manifestId = "3381894269381868866";
    hash = "sha256-HJpRCQDr6ss+Zi6PdXaic6bZzmjfHAgN652CKbBLMfM=";
  };

in stdenv.mkDerivation rec {
  name = "unturned-server";

  buildInputs = [ baseDepot extraDepot ];

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  # Use src for baseDepot and srcs for extraDepot
  src = baseDepot;
  srcs = [ extraDepot ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # Copy files from $src (baseDepot) and $srcs (extraDepot)
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