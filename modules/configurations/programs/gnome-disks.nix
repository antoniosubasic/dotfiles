{ utilities, ... }:

{
  programs.gnome-disks.enable = utilities.hasTags [
    "gui"
    "personal"
  ];
}
