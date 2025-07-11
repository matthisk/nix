{ isWSL, inputs }:

{ config, lib, pkgs, unstable, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  home.stateVersion = "24.05";

  fonts.fontconfig.enable = true;

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
    pkgs.nixfmt-classic
    pkgs.delta
    pkgs.gh
    pkgs.fnm

    # Install fonts
    pkgs.nerd-fonts.fira-code

    # Globally available language servers
    pkgs.nixd
    pkgs.zls
    pkgs.nodePackages.typescript-language-server
    pkgs.lua-language-server
  ] ++ (lib.optionals isDarwin [
    # This comes pre-installed on Linux
    pkgs.cachix
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.chromium
    pkgs.firefox
    pkgs.inotify-tools
  ]);

  programs.gpg.enable = !isDarwin;
  programs.direnv.enable = true;
  programs.autojump.enable = true;

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

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
      gpl = "git pull";
      gt = "git tag";
    } // (if isLinux then {
      pbcopy = "xclip";
      pbpaste = "xclip -o";
    } else
      { });

    shellInit = ''
      if test -f ~/.secrets
        source ~/.secrets
      end
      fnm env --use-on-cd --shell fish | source
    '';

    interactiveShellInit = ''
      scmpuff init --shell=fish | source

      # This is required for commit signing from cmdline
      if isatty
          set -x GPG_TTY (tty)
      end

      # Utilities for path navigation
      function ...
          ../..
      end
      function ....
          ../../..
      end
    '';

    functions = {
      # Utilities to quickly clone git repos
      hubgit = ''
        git clone git@github.com:$argv[1]/$argv[2] $HOME/dev/github.com/$argv[1]/$argv[2]
        cd $HOME/dev/github.com/$argv[1]/$argv[2]
      '';
      miro_hubgit = ''
        git clone git@github.com:miroapp-dev/$argv $HOME/dev/github.com/miroapp-dev/$argv
        cd $HOME/dev/github.com/miroapp-dev/$argv
      '';
      tthisk_hubgit = ''
        git clone git@github.com:matthisk/$argv $HOME/dev/github.com/matthisk/$argv
        cd $HOME/dev/github.com/tthisk/$argv
      '';

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
    userEmail = "m@tthisk.nl";
    signing = {
      key = "AB088E23691F352C";
      signByDefault = true;
    };
    extraConfig = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      color.ui = true;
      init.defaultBranch = "main";
      push.default = "tracking";
      github.user = "matthisk";
      branch.autosetuprebase = "always";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = if isDarwin then "UseKeychain yes" else "";
    # This option is available on master but not in 23.11.
    # Enable it once a new version ships.
    # addKeysToAgent = "yes";
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
      vimPlugins.cmp-nvim-lsp
      vimPlugins.nvim-jdtls
      vimPlugins.nvim-lspconfig
      vimPlugins.dirbuf-nvim
      vimPlugins.lsp-format-nvim
      vimPlugins.nvim-surround
      vimPlugins.nvim-tree-lua
      vimPlugins.luasnip
      vimPlugins.neoterm
      vimPlugins.telescope-nvim
    ];
  };

  programs.alacritty = {
    enable = !isWSL;
    settings = (builtins.fromTOML
      (builtins.readFile "${unstable.alacritty-theme}/share/alacritty-theme/tokyo_night.toml")) // {
        shell.program = "${pkgs.fish}/bin/fish";
        window = {
          decorations = if isDarwin then "Transparent" else "Full";
          startup_mode = if isDarwin then "Maximized" else "Fullscreen";
          opacity = 0.9;
          padding = { y = 27; };
        };
        font = {
          # Haven't figured a way to get the linux font and mac font to behave the same on high DPI screens.
          # For now just setting a different font size on each OS.
          size = if isDarwin then 14 else 12;
          normal = { family = "FiraCode Nerd Font Mono"; };
        };
      };
  };
}
