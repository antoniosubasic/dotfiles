{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [ "--reverse" ];
  };
}
