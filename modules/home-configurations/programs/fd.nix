{ utils, ... }:

{
  programs.fd = {
    enable = utils.hasTag "shell";
    hidden = true;
    ignores = [
      ".git"
      "node_modules"
    ];
  };
}
