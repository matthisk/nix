{ inputs, pkgs, ... }:

{
    homebrew = {
        enable = true;
        casks = [
          "raycast"
          "zed"
        ];
        brews = [
          "miro-buf"
        ];
        taps = [{
          name = "miroapp-dev/homebrew-miro";
          clone_target = "git@github.com:miroapp-dev/homebrew-miro.git";
          force_auto_update = true;
        }];
    };

    programs.fish.shellInit = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    # Home directory should already exist.
    # See: https://github.com/LnL7/nix-darwin/issues/423
    users.users.matthiskheimensen = {
        home = "/Users/matthiskheimensen";
        shell = pkgs.fish;

    };
}
