{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "docker-desktop"
      "elasticvue"
      "finicky"
      "wispr-flow"
      "agentsview"
      "zen"
      "paseo"
    ];
    # The Miro specific dependencies require Artifactory env variables.
    # As of right now I haven't found a way for Nix to propagate these env variables.
    # It is easiest if you just comment out this line and install these brews manually.
    # brews = [ "miro-buf" "miro-dev-proxy" ];
    taps = [
      {
        name = "miroapp-dev/homebrew-miro";
        clone_target = "git@github.com:miroapp-dev/homebrew-miro.git";
        force_auto_update = true;
      }
    ];
  };

  # Sets HOMEBREW_PREFIX, MANPATH, INFOPATH etc. Note that this also prepends
  # the Homebrew bins to PATH, which is undone below.
  programs.fish.shellInit = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';

  # Move Homebrew and ~/.local/bin behind the Nix profiles. This has to live in
  # the home-manager fish config: ~/.config/fish/config.fish runs after
  # /etc/fish/config.fish and re-prepends home.sessionPath (~/.local/bin).
  # `--path` edits $PATH directly; without it fish_add_path writes the
  # universal fish_user_paths, which always ends up in front of PATH.
  home-manager.users.matthiskheimensen.programs.fish.shellInit = lib.mkAfter ''
    fish_add_path --global --move --append --path /opt/homebrew/bin /opt/homebrew/sbin $HOME/.local/bin
  '';

  # Home directory should already exist.
  # See: https://github.com/LnL7/nix-darwin/issues/423
  users.users.matthiskheimensen = {
    home = "/Users/matthiskheimensen";
    shell = pkgs.fish;
  };
}
