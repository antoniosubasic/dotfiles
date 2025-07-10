let
  touchpads = [
    {
      name = "GXTP5400:00 27C6:0F91 Touchpad";
      vendorId = "27C6";
      productId = "0F91";
    }
  ];

  mice = [
    {
      name = "Logitech M705";
      vendorId = "046D";
      productId = "406D";
    }
    {
      name = "Logitech USB Receiver";
      vendorId = "046D";
      productId = "C547";
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
      mice = map (
        identifier:
        identifier
        // {
          enable = true;
          leftHanded = false;
          middleButtonEmulation = false;
          acceleration = 0.2;
          accelerationProfile = "none";
          scrollSpeed = 1;
          naturalScroll = false;
        }
      ) mice;
    };
  };
}
