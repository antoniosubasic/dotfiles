{ osConfig, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = osConfig.programs.hyprland.package;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";

      input = {
        kb_layout = "at";
        numlock_by_default = true;
        sensitivity = 0.2;
        accel_profile = "flat";
      };

      monitor = [
        "HDMI-A-1, preferred, auto, 1"
        "DP-1, preferred, -1920x0, 1.5"
      ];

      xwayland.force_zero_scaling = true;
      master.new_status = "master";

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizeactive"
        "$mod ALT, mouse:272, resizeactive"
      ];

      bindr = [
        "SUPER, SUPER_L, exec, pkill rofi || rofi -show drun"
      ];

      bind = [
        #################
        # App Shortcuts #
        #################
        "$mod, T, exec, $terminal"
        "$mod, C, killactive"
        "$mod, E, exec, $fileManager"

        ################
        # Window Focus #
        ################
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        ######################
        # Workspace Movement #
        ######################
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod ALT, l, workspace, +1"
        "$mod ALT, h, workspace, -1"
      ];

      layerrule = [
        "noanim, rofi"
      ];

      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      general = {
        gaps_out = 10;
        "col.active_border" = "rgba(ffffff80)";
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };
    };
  };
}
