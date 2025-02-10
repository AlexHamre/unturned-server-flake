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

  additionalDepot1 = fetchSteam {
    name = "unturned-server-other";
    appId = "1110390";
    depotId = "1110394";
    manifestId = "3609612843127309127";
    hash = "sha256-RqGZfRf66rVUmChQF4ERGDd2vpIoWhkvEbL+r7+5JkQ=";
  };

  additionalDepot2 = fetchSteam {
    name = "steam-redist";
    appId = "90";
    depotId = "1006";
    manifestId = "7138471031118904166";
    hash = "sha256-OtPI1kAx6+9G09IEr2kYchyvxlPl3rzx/ai/xEVG4oM=";
  };

in stdenv.mkDerivation rec {
  name = "unturned-server";

  buildInputs = [ baseDepot extraDepot additionalDepot1 additionalDepot2 ];

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  # Use src for baseDepot and srcs for extraDepot, additionalDepot1, and additionalDepot2
  src = baseDepot;
  srcs = [ extraDepot additionalDepot1 additionalDepot2 ];

  # Custom unpack phase to handle multiple directories and permissions
  unpackPhase = ''
    runHook preUnpack

    # Create a temporary directory for the unpacked files
    mkdir -p $TMPDIR/unpacked

    # Unpack all depots with adjusted permissions
    for dep in $src $srcs; do
      cp -r $dep/* $TMPDIR/unpacked/
    done

    # Fix permissions by setting umask to allow all permissions for directories and files
    umask 0022
    chmod -R u+rwX,go+rX $TMPDIR/unpacked

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # Copy files from the unpacked directory to $out
    cp -r --no-preserve=mode $TMPDIR/unpacked/* $out/

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
