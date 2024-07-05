This repository now uses Nix's [home-manager](https://nix-community.github.io/home-manager/)
as the primary mechanism for both making sure reasonable tooling is installed on hosts, as well
as managing consistent configurations across hosts.

Updating on a new host means either installing a basic Nix environment:
  * [Install a basic Nix environment](https://nixos.org/download/#nix-install-linux)
  * [Install the Home Manager channel](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)
  * Link one of the existing host configurations (or copy and modify to make a
    new one) to `~/.config/home-manager/home.nix`

For Darwin hosts, you'll want to update `~/.nixpkgs/darwin-configuration.nix` to
include the line `home-manager.users.<username> = import /Users/<username>/.system/hosts/<hostname>.nix`.
Which is a little irritating.

You can then install all the tooling by running:
  * MacOS: `darwin-rebuild switch`
  * Linux: `home-manager switch`
