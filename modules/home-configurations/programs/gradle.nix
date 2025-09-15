{ upkgs, utilities, ... }:

{
  programs.gradle = {
    enable = utilities.hasTag "dev";
    package = upkgs.gradle_9;
  };
}
