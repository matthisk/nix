{ nixpkgs, overlays, inputs }:
let
  machineConfig = ./machines/macbook-pro-m1.nix;

  # Use the nix-darwin function to create system configuration.
  systemFunc = inputs.darwin.lib.darwinSystem;
in systemFunc rec {
 modules = [
  machineConfig
 ];
}
