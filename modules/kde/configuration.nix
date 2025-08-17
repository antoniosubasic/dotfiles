{ utilities, ... }:

{
  imports = utilities.importNixFiles ./configurations;

  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };
}
