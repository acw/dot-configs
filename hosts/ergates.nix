{ ... }: {
  nixpkgs.hostPlatform = { system = "aarch64-darwin"; };

  users.users.adamwick = {
    name = "adamwick";
    home = "/Users/adamwick";
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Create /etc/zshrc that loads the nix-darwin environment.
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
