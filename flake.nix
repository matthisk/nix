{
  description = "OS configuration";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Build a custom WSL installer
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bobthefish = {
      type = "github";
      owner = "oh-my-fish";
      repo = "theme-bobthefish";
      flake = false;
    };

    fish-fzf = {
      type = "github";
      owner = "PatrickF1";
      repo = "fzf.fish";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let mkSystem = import ./lib/mkSystem.nix { inherit nixpkgs inputs; };
    in {
      darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
        system = "aarch64-darwin";
        user = "matthiskheimensen";
        darwin = true;
      };

      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
        system = "aarch64-linux";
        user = "matthiskheimensen";
      };

      nixosConfigurations.vm-intel = mkSystem "vm-intel" {
        system = "x86_64-linux";
        user = "matthiskheimensen";
      };

      nixosConfigurations.wsl = mkSystem "wsl" {
        system = "x86_64-linux";
        user = "matthiskheimensen";
        wsl = true;
      };
    };
}
