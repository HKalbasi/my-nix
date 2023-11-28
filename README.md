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
Create a `personal.nix` file:
```
{
  git = {
    name = "Your Name";
    email = "youremail@email.com";
  };
  proxychains = {
    enable = true;
    proxies = {
      randomName = {
        enable = true;
        type = "socks5";
        host = "192.168.12.150";
        port = 10808;
      };
    };
  };
}
```
