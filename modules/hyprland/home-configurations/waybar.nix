{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      position = "top";
      margin = "8 16 0";
      mod = "dock";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "tray"
        "network"
        "bluetooth"
        "battery"
        "temperature"
        "pulseaudio"
        "clock"
      ];
      "hyprland/window".format = "{}";
      "hyprland/workspaces".persistent-workspaces."*" = [
        1
        2
        3
      ];
      tray = {
        icon-size = 18;
        spacing = 20;
      };
      network = {
        format-icons = [
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format-wifi = "{icon}";
        format-ethernet = "";
        format-linked = "󰄡";
        format-disconnected = "";
        tooltip-format = "{essid} ({signalStrength}%) - {gwaddr}";
        tooltip-format-ethernet = "{ifname} - {gwaddr}";
        tooltip-format-disconnected = "Disconnected";
      };
      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-connected = "󰂱 {num_connections}";
        tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click = "bluetooth toggle";
      };
      battery = {
        full-at = 95;
        states = {
          warning = 35;
          critical = 10;
        };
        format = "{icon}";
        format-plugged = "";
        format-charging = "󰂄";
        format-icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        tooltip-format = "{capacity}%";
      };
      temperature = {
        thermal-zone = 1;
        format = " {temperatureC}°C";
        critical-threshold = 80;
        format-critical = " {temperatureC}°C";
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 0%";
        on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
        on-click-right = "pavucontrol";
        on-scroll-up = "wpctl set-volume -l 1.3 @DEFAULT_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_SINK@ 5%-";
        scroll-step = 5;
        format-icons = {
          headphone = "󱡏";
          hands-free = "󱡏";
          headset = "󱡏";
          default = [
            ""
            ""
          ];
        };
      };
      clock = {
        format = "{:%H:%M %a}";
        tooltip-format = "{calendar}";
        calendar = {
          format = {
            months = "<span color='#D3D04F'><b>{}</b></span>";
            days = "<span color='#93B1A6'><b>{}</b></span>";
            weekdays = "<span color='#8EAC50'><b>{}</b></span>";
            today = "<span color='#8EAC50'><b><u>{}</u></b></span>";
          };
        };
      };
      backlight = {
        device = "intel_backlight";
        format = "{icon} {percent}%";
        format-icons = [
          "󰃞"
          "󰃟"
          "󰃠"
        ];
        on-scroll-up = "brightnessctl set 10%+";
        on-scroll-down = "brightnessctl set 10%-";
        min-length = 6;
      };
      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = " {volume}%";
        format-source-muted = " Muted";
        on-click = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
        on-click-right = "pavucontrol";
        on-scroll-up = "wpctl set-volume -l 1.3 @DEFAULT_SOURCE@ 5%+";
        on-scroll-down = "wpctl set-volume -l 1.3 @DEFAULT_SOURCE@ 5%-";
        scroll-step = 5;
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font, monospace, sans-serif";
        font-weight: bold;
        font-size: 16px;
      }

      window#waybar {
        border-radius: 16px;
        background: #0d1117;
        color: #93B1A6;
      }

      tooltip {
        background: #0d1117;
        border-radius: 14px;
        border: 1px solid #21262d
      }

      tooltip label {
        color: #93B1A6;
      }

      #workspaces {
        border-radius: 16px 24px 24px 16px;
        margin: 0;
        background-color: rgba(255, 255, 255, 0.08);
      }

      #workspaces button {
        min-width: 28px;
        border-radius: 20px;
        margin: 8px 0;
      }

      #workspaces button:not(:last-child) {
        margin-right: 4px;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.08);
      }

      #workspaces button.active,
      #workspaces button.active:hover {
        background: #5C8374;
        color: #0d1117;
      }

      #clock,
      #battery,
      #pulseaudio,
      #network,
      #bluetooth,
      #temperature,
      #workspaces,
      #backlight {
        padding: 0px 14px;
        background-color: rgba(255, 255, 255, 0.08);
      }

      #tray {
        padding: 0px 16px;
      }

      #network {
        border-radius: 24px 0 0 24px;
        padding-left: 24px;
      }

      #battery.warning {
        color: orange;
      }

      #battery.critical {
        color: red;
      }

      #temperature.critical {
        color: red;
      }

      #clock {
        padding-right: 16px;
        border-radius: 0 16px 16px 0;
      }
    '';
  };
}
