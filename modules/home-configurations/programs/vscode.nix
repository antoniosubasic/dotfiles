{ upkgs, utilities, ... }:

{
  programs.vscode = {
    enable = utilities.hasTags [
      "gui"
      "dev"
    ];
    package = upkgs.vscode;
  };
}
