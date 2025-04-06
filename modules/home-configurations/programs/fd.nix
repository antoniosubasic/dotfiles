{ utilities, ... }:

{
  programs.fd = {
    enable = utilities.hasTag "shell";
    hidden = true;
    ignores = [
      ".git"
      "node_modules"
    ];
  };
}
