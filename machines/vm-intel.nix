{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware/vm-aarch64.nix
    ./vm-shared.nix
  ];

  # Interface is this on M1
  networking.interfaces.ens33.useDHCP = true;

  # This works through our custom module imported above
  virtualisation.vmware.guest.enable = true;
}
