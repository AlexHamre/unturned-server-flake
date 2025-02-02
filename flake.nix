{
  description = "NixOS module for the Unturned dedicated server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    steam-fetcher = {
      url = "github:AlexHamre/steam-fetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    steam-fetcher,
  }: let
    # The Steam Nix fetcher only supports x86_64 Linux.
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        overlays = [
          steam-fetcher.overlays.default
          self.overlays.default
        ];
      };
    lintersFor = system: let
      pkgs = pkgsFor system;
    in
      with pkgs; [
        alejandra
      ];
  in {
    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            nil # Nix LS
          ]
          ++ lintersFor system;
      };
    });

    checks = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      fmt = pkgs.runCommandLocal "alejandra" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${./.} > "$out"
      '';
    });

    formatter = forAllSystems (system: (pkgsFor system).alejandra);

    nixosModules = rec {
      unturned = import ./nixos-modules/unturned.nix {inherit self steam-fetcher;};
      default = unturned;
    };
    overlays.default = final: prev: {
      unturned-server-unwrapped = final.callPackage ./pkgs/unturned-server {};
      unturned-server = final.callPackage ./pkgs/unturned-server/fhsenv.nix {};
    };
    packages = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      unturned-server = pkgs.unturned-server;
      default = pkgs.unturned-server;
    });
  };
}
