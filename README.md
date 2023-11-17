# My nix os config

Add these channels:
```
sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
sudo nix-channel --update
```
Clone the repository, then add `main.nix` to the `configuration.nix` imports:
```
{ ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/user/my-nix/main.nix
    ];
}
```