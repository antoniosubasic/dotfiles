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
      cursor.style = "Beam";
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
          foreground = "#c0caf5";
        };
        normal = {
          black = "#15161e";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
        };
        bright = {
          black = "#414868";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#c0caf5";
        };
      };
    };
  };
}
