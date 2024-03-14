{ pkgs, inputs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  # Disable emergency mode to debug the mount failure I'm experiencing atm
  systemd.enableEmergencyMode = false;

  users.users.matthiskheimensen = {
    isNormalUser = true;
    home = "/home/matthiskheimensen";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$Tk8XgXz7jBJawmkGoI.P91$6h5SkiEp.cQIaFoyqXQ7BrO7aZcwt46H/dy7h4ugeC0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILYr7yTqfml9anrJkxlaNL75dZlbjExz3RiocMgrzzlW matthiskheimensen@gmail.com"
    ];
  };
}
