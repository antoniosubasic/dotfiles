{ userVars, ... }:

{
  programs.plasma.kwin = {
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
    virtualDesktops.number =
      if builtins.hasAttr "virtual_desktops" userVars then userVars.virtual_desktops else 1;
    effects.desktopSwitching.navigationWrapping = true;
  };
}
