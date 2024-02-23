{ inputs, pkgs, ... }:

{
    homebrew = {
        enable = true;
        casks = [
          "raycast"
        ];
    };

    # Home directory should already exist.
    # See: https://github.com/LnL7/nix-darwin/issues/423
    users.users.matthiskheimensen = {
        home = "/Users/matthiskheimensen";
        shell = pkgs.fish;
    };
}
