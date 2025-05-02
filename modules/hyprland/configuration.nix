{ pkgs, hyprPkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      package = hyprPkgs.hyprland;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    libsecret
    seahorse

    libnotify
    mako

    rofi-wayland
  ];

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
