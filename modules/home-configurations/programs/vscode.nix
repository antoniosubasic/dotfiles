{ utilities, unstable, ... }:

{
  programs.vscode = {
    enable = utilities.hasTags [
      "gui"
      "dev"
    ];
    package = unstable.vscode;
  };
}
