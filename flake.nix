{
  description = "NixOS module for the Unturned dedicated server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    steam-fetcher = {
      url = "github:aidalgol/nix-steam-fetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steam
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    steam-fetcher,
  }: {
    nixosModules = rec {
      unturned = import ./nixos-modules/unturned.nix {inherit self steam-fetcher;};
      default = unturned;
    };
    overlays.default = final: prev: {
      unturned-server-unwrapped = final.callPackage ./pkgs/unturned-server {};
      unturned-server = final.callPackage ./pkgs/unturned-server/fhsenv.nix {};
    };
  };
}