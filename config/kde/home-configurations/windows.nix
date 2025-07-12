{ lib, utilities, ... }:

{
  programs.plasma.kwin =
    {
      titlebarButtons = {
        left = [
          "more-window-actions"
        ];
        right = [
          "minimize"
          "maximize"
          "close"
        ];
      };
      edgeBarrier = 0;
      cornerBarrier = true;
    }
    // lib.optionalAttrs (utilities.hasTag "virtual_desktops") {
      virtualDesktops.number = 2;
    };
}
