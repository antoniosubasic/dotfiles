{
  config,
  pkgs,
  utilities,
  ...
}:

{
  programs.gh = {
    enable = utilities.hasTags [
      "shell"
      "personal"
    ];
    extensions = with pkgs; [
      gh-contribs
    ];
    gitCredentialHelper.enable = false;
    settings = {
      git_protocol = "ssh";
      editor = config.programs.git.extraConfig.core.editor;
    };
  };
}
