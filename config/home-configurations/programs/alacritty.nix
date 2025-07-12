{ utilities, ... }:

{
  programs.alacritty = {
    enable = utilities.hasTags [
      "gui"
      "personal"
    ];
    settings = {
      env.TERM = "xterm-256color";
      window = {
        dimensions = {
          columns = 125;
          lines = 30;
        };
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
        opacity = 0.99;
      };
      scrolling.history = 10000;
      selection.save_to_clipboard = true;
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
      keyboard.bindings = [
        {
          key = "N";
          mods = "Control";
          action = "SpawnNewInstance";
        }
      ];
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#a9b1d6";
        };
        normal = {
          black = "#32344a";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#ad8ee6";
          cyan = "#449dab";
          white = "#787c99";
        };
        bright = {
          black = "#444b6a";
          red = "#ff7a93";
          green = "#b9f27c";
          yellow = "#ff9e64";
          blue = "#7da6ff";
          magenta = "#bb9af7";
          cyan = "#0db9d7";
          white = "#acb0d0";
        };
      };
    };
  };
}
