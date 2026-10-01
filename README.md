# Materialious.nix
An unofficial method to install Materialious on NixOS using flake.nix

## on flake.nix file
```
nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # replace 26.05 with any version you want
    materialious = {
      url = "github:medofarag/Materialious.nix";
      inputs.nixpkgs.follows = "nixpkgs"; # optional
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { 
        inherit inputs;
      };
      modules = [
        ./configuration.nix                         # Your main configuration
      ];
    };
  };
}
```


## on configuration.nix file
```nix
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.materialious.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```


