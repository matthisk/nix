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
      pkgs.tig
      pkgs.scmpuff

      # Globally available language servers
      pkgs.nixd
      pkgs.zls
      pkgs.nodePackages.typescript-language-server
      pkgs.lua-language-server
    ];

    programs.direnv.enable = true;
    programs.autojump.enable = true;
    
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
          gps = "git push";
          gt = "git tag";
        };

        interactiveShellInit = ''
          scmpuff init --shell=fish | source
        '';

        functions = {
          gitignore = "curl -sL https://www.gitignore.io/api/$argv";

          dvd = ''
            echo "use flake \"github:the-nix-way/dev-templates?dir=$argv\"" >> .envrc
            direnv allow
          '';

          dvt = ''
            nix flake init -t "github:the-nix-way/dev-templates#$argv"
            direnv allow
          '';
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
      extraLuaConfig = (builtins.readFile ./vim-init.lua);
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
