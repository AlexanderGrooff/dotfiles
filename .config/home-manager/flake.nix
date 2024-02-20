{
  description = "Home Manager configuration of alex";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHome = hostConfig: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit hostConfig; };
      };
    in {
      # Load config per host
      homeConfigurations = {
        # Default
        "alex" = mkHome {
          desktop = false;
        };

        "mu" = mkHome {
          desktop = true;
        };
      };
    };
}
