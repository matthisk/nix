{ inputs, pkgs, ... }:

{
    homebrew = {
        enable = true;
        casks = [
          "raycast"
        ];
    };
}
