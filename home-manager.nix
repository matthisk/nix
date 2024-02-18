{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.matthisk = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.11";

    home.packages = [
      pkgs.httpie 
      pkgs.neovim 
      pkgs.htop
      pkgs.bat
      pkgs.jq
      pkgs.ripgrep
      pkgs.watch
      pkgs.nodejs
      pkgs.firefox
      pkgs.ungoogled-chromium
    ];

    programs.bash.enable = true;

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      antidote = {
        enable = true;
	plugins = [
          "zsh-users/zsh-autosuggestions"
	  "ohmyzsh/ohmyzsh path:themes/minimal.zsh-theme"
	];
      };
    };

    programs.kitty = {
      enable = true;
      extraConfig = builtins.readFile ./kitty;
    };

    programs.git = {
      enable = true;
      userName = "Matthisk Heimensen";
      userEmail = "m@tthisk.nl";
      extraConfig = {
         color.ui = true;
	 init.defaultBranch = "main";
	 push.default = "tracking";
	 github.user = "matthisk";
	 branch.autosetuprebase = "always";
      };
    };

    programs.home-manager.enable = true;
  };
}
