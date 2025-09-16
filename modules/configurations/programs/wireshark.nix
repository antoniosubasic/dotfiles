{ pkgs, utilities, ... }:

{
  programs.wireshark = {
    enable = utilities.hasTags [
      "gui"
      "dev"
    ];
    package = pkgs.wireshark;
  };
}
