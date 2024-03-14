{ config, pkgs, lib, vmwareGuestUnstable, ... }: {
  # Disable the 23.11 version of vmware-guest module as it is not compatible with aarch64
  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  imports = [
    ./hardware/vm-aarch64.nix
    ./vm-shared.nix
    # Now include our customer version of vmware guest module.
    ../modules/vmware-guest.nix
  ];

  # Setup qemu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # Interface is this on M1
  networking.interfaces.ens160.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # This works through our custom module imported above
  virtualisation.vmware.guest.enable = true;
  # virtualisation.vmware.guest.headless = true;
}
