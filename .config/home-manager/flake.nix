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
      mkHome = hostname: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Use host-specific config if it exists
        modules = if builtins.pathExists ./${hostname}.nix then [ ./home.nix ./${hostname}.nix ] else [ ./home.nix ];
        extraSpecialArgs = { inherit hostname; };
      };
    in {
      # Load config per host
      homeConfigurations = {
        "alpha" = mkHome "alpha";
        "alpha-windows" = mkHome "alpha";
      };
    };
}
