{
  programs.plasma.panels = [
    {
      alignment = "center";
      location = "bottom";
      floating = true;
      lengthMode = "fill";
      screen = "all";
      widgets = [
        "org.kde.plasma.kickoff"
        "org.kde.plasma.pager"
        {
          iconTasks = {
            launchers = [
              "preferred://filemanager"
              "applications:code.desktop"
              "applications:discord.desktop"
              "preferred://browser"
            ];
            behavior.wheel.switchBetweenTasks = false;
          };
        }
        "org.kde.plasma.marginsseparator"
        {
          systemTray = {
            items = {
              hiden = [
                "org.kde.plasma.brightness"
              ];

              shown = [
                "org.kde.plasma.volume"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.notifications"
                "dropbox-client-PID"
                "org.kde.plasma.battery"
              ];

              configs = {
                battery.showPercentage = true;
              };
            };
          };
        }
        {
          digitalClock = {
            date = {
              enable = true;
              format.custom = "ddd dd MMM";
            };
            time = {
              format = "24h";
              showSeconds = "always";
            };
          };
        }
        "org.kde.plasma.showdesktop"
      ];
    }
  ];
}
