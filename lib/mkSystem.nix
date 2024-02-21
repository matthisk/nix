{ nixpkgs, inputs }:

name:
{
    system,
    user,
    darwin ? false
}:

let
  machineConfig = ./machines/${name}.nix;

  # Use the nix-darwin function to create system configuration.
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
in systemFunc rec {
  inherit system;

  modules = [
    machineConfig
  ];
}
