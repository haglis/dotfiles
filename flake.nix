{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Keep Python current without moving the whole system to unstable.
    nixpkgs-python.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-python, nix-homebrew, home-manager, ... }: {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        ./configuration.nix 
	nix-homebrew.darwinModules.nix-homebrew
	home-manager.darwinModules.home-manager
	({ pkgs, ... }: {
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.extraSpecialArgs.pythonPkgs = import nixpkgs-python {
	    system = pkgs.stdenv.hostPlatform.system;
	    config = pkgs.config;
	  };
	  home-manager.users.jianhual = import ./home.nix;
	})
      ];
    };
  };
}
