{ config, pkgs, ... }: {
  programs.bat = {
    enable = true;
    themes = {
      tokyonight = {
        # use nix-prefetch-git to get necessary info
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "b262293ef481b0d1f7a14c708ea7ca649672e200";
          sha256 = "1cd8wxgicfm5f6g7lzqfhr1ip7cca5h11j190kx0w52h0kbf9k54";
        };
        file = "extras/sublime/tokyonight_night.tmTheme";
      };
    };
    extraPackages = with pkgs.bat-extras; [ batgrep batman prettybat ];
  };
}
