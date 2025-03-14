{
  programs.plasma = {
    configFile."powerdevil.notifyrc"."Event/lowperipheralbattery".Action = "";
    powerdevil = {
      AC = {
        dimDisplay = {
          enable = true;
          idleTimeout = 300;
        };
        turnOffDisplay.idleTimeout = 330;
        turnOffDisplay.idleTimeoutWhenLocked = 20;
        autoSuspend = {
          action = "sleep";
          idleTimeout = 420;
        };
        powerProfile = "balanced";
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standby";
      };
      battery = {
        dimDisplay = {
          enable = true;
          idleTimeout = 150;
        };
        turnOffDisplay.idleTimeout = 180;
        turnOffDisplay.idleTimeoutWhenLocked = 20;
        autoSuspend = {
          action = "sleep";
          idleTimeout = 270;
        };
        powerProfile = "balanced";
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standby";
      };
      batteryLevels.lowLevel = 10;
      lowBattery = {
        dimDisplay = {
          enable = true;
          idleTimeout = 60;
        };
        turnOffDisplay.idleTimeout = 90;
        turnOffDisplay.idleTimeoutWhenLocked = 20;
        autoSuspend = {
          action = "sleep";
          idleTimeout = 150;
        };
        powerProfile = "powerSaving";
        whenLaptopLidClosed = "sleep";
        whenSleepingEnter = "standby";
      };
    };
  };
}
