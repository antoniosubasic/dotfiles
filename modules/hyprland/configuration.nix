{ pkgs, hyprPkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      package = hyprPkgs.hyprland;
    };
    waybar.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libnotify
    mako

    rofi-wayland
  ];
}
