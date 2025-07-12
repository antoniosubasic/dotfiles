{
  programs.plasma.panels = [
    {
      floating = true;
      screen = "all";
      widgets = [
        { kickoff.icon = "nix-snowflake"; }
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
          systemTray.items = {
            hidden = [
              "org.kde.plasma.katesessions"
            ];
            shown = [
              "org.kde.plasma.brightness"
              "org.kde.plasma.volume"
              "org.kde.plasma.bluetooth"
              "org.kde.plasma.clipboard"
              "org.kde.plasma.notifications"
              "org.kde.plasma.battery"
              "dropbox-client-PID"
            ];
          };
        }
        {
          digitalClock = {
            date = {
              enable = true;
              format.custom = "ddd dd MMM";
            };
            time.showSeconds = "always";
          };
        }
        "org.kde.plasma.showdesktop"
      ];
    }
  ];
}
