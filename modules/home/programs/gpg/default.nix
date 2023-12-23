{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentryFlavor = "qt";
  };
}
