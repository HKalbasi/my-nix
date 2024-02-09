{
  description = "Hamid's system configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations =
      let
        system = "x86_64-linux";
        specialArgs = inputs // {
          unstable = inputs.unstable.legacyPackages.${system};
        };
      in
      {
        main = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./main.nix ];
        };
      };
  };

}
