{ inputs }:

{ config, lib, pkgs, unstable, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in  {
    home.stateVersion = "23.11";

    home.packages = [
      pkgs.httpie 
      pkgs.htop
      pkgs.bat
      pkgs.jq
      pkgs.fzf
      pkgs.fd
      pkgs.tree
      pkgs.ripgrep
      pkgs.watch

      # Globally available language servers
      pkgs.nixd
      pkgs.nodePackages.typescript-language-server
    ];
    
    programs.fish = {
        enable = true;

        # Setup git aliases
        shellAliases = {
          g = "git";
          ga = "git add";
          gc = "git commit";
          gco = "git checkout";
          gcp = "git cherry-pick";
          gdiff = "git diff";
          gl = "git prettylog";
          gp = "git push";
          gs = "git status";
          gt = "git tag";
        };

        plugins = [
          {
            name = "bobthefish";
            src = inputs.bobthefish;
          }
          {
            name = "fish.fzf";
            src = inputs.fish-fzf;
          }
        ];
    };

    programs.git = {
      enable = true;
      userName = "Matthisk Heimensen";
      userEmail = "matthisk@miro.com";
      extraConfig = {
         color.ui = true;
	 init.defaultBranch = "main";
	 push.default = "tracking";
	 github.user = "matthisk";
	 branch.autosetuprebase = "always";
      };
    };

    programs.neovim = {
      enable = true;
      extraLuaConfig = (import ./vim-config.nix) { inherit inputs; };
      plugins = with pkgs; [
        vimPlugins.tokyonight-nvim
        vimPlugins.lualine-nvim
	vimPlugins.gitsigns-nvim
        vimPlugins.flash-nvim
        vimPlugins.nvim-treesitter.withAllGrammars
        vimPlugins.vim-nix
        vimPlugins.dressing-nvim
        vimPlugins.plenary-nvim
        vimPlugins.nvim-cmp
        vimPlugins.nvim-jdtls
        vimPlugins.nvim-lspconfig
        (pkgs.vimUtils.buildVimPlugin {
          name = "nvim-telescope";
          src = inputs.nvim-telescope;
        })
      ];
    };

    programs.alacritty = {
      enable = true;
      settings = (builtins.fromTOML (builtins.readFile "${unstable.alacritty-theme}/tokyo-night.toml")) // {
        shell.program = "${pkgs.fish}/bin/fish";
        window = {
          decorations = "transparent";
          padding = {
            y = 27;
          };
        };
        dynamic_title = true;
        font = {
          size = 14;
          normal = {
            family = "Monaco for Powerline";
          };
        };
      };
    };
}
