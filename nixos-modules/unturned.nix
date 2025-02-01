{
  self,
  steam-fetcher,
}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.unturned;
  stateDir = "/var/lib/unturned";
in {
  config.nixpkgs.overlays = [self.overlays.default steam-fetcher.overlays.default];

  options.services.unturned = {
    enable = lib.mkEnableOption (lib.mdDoc "Unturned Dedicated Server");

    port = lib.mkOption {
      type = lib.types.port;
      default = 9001;
      description = lib.mdDoc "The port on which to listen for incoming connections.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc "Whether to open ports in the firewall.";
    };

    # Any options you want to expose for the game server, which will vary from game to game.
  };

  config = {
    users = {
      users.unturned = {
        isSystemUser = true;
        group = "unturned";
        home = stateDir;
      };
      groups.unturned = {};
    };

    systemd.services.unturned = {
      description = "Unturned dedicated server";
      requires = ["network.target"];
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
          Type = "exec";
          User = "unturned";
          ExecStart = "${pkgs.unturned-server}/ServerHelper.sh +LanServer/MyServer";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [
        cfg.port
        (cfg.port + 1) # Steam server browser
      ];
    };
  };
}