{ tags, utils, ... }:

{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = utils.hasTag tags "unfree";
}
