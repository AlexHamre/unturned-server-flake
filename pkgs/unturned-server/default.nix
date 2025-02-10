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
    depotId = "1110393"; # Replace with the correct depot ID
    manifestId = "3381894269381868866"; # Replace with the correct manifest ID
    hash = "sha256-HJpRCQDr6ss+Zi6PdXaic6bZzmjfHAgN652CKbBLMfM="; # Replace with the correct hash
  };

in stdenv.mkDerivation rec {
  name = "unturned-server";
  
  buildInputs = [ baseDepot extraDepot ];

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  src = baseDepot;
  srcs = [ extraDepot ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # Adjust permissions on the directories before copying files
    find $src -type d -exec chmod 755 {} \;
    find $src -type f -exec chmod 644 {} \;

    for dep in $srcs; do
      find $dep -type d -exec chmod 755 {} \;
      find $dep -type f -exec chmod 644 {} \;
    done

    # Now copy files after setting proper permissions
    cp -r $src/* $out/
    for dep in $srcs; do
      cp -r $dep/* $out/
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
