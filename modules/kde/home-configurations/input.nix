let
  touchpads = [
    {
      name = "DLL0A81:00 04F3:314B Touchpad";
      vendorId = "04F3";
      productId = "314B";
    }
  ];

  mice = [
    {
      name = "Logitech M705";
      vendorId = "046D";
      productId = "406D";
      enable = true;
      leftHanded = false;
      middleButtonEmulation = false;
      acceleration = 0.2;
      accelerationProfile = "none";
      scrollSpeed = 1;
      naturalScroll = false;
    }
  ];
in
{
  programs.plasma = {
    input = {
      keyboard.numlockOnStartup = "on";
      touchpads = map (
        identifier:
        identifier
        // {
          enable = true;
          disableWhileTyping = true;
          leftHanded = false;
          middleButtonEmulation = false;
          pointerSpeed = 0;
          accelerationProfile = "none";
          scrollSpeed = 0.3;
          scrollMethod = "twoFingers";
          naturalScroll = true;
          tapToClick = true;
          tapAndDrag = true;
          tapDragLock = false;
          twoFingerTap = "rightClick";
          rightClickMethod = "bottomRight";
        }
      ) touchpads;
      mice = mice;
    };
  };
}
