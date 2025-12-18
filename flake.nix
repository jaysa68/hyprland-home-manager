{
  description = "Home Manager configuration of jaysa";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "ocf-nix/nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "ocf-nix/nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "ocf-nix/nixpkgs";
    };
    ocf-nix = {
      url = "github:ocf/nix";
    };
    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "ocf-nix/nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    inputs@{ self, ocf-nix, home-manager, firefox-addons, ... }:
    let
      inherit (ocf-nix.inputs) nixpkgs; # same version of nixpkgs as ocf
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      #nixpkgs = { 
      #  overlays = [
      #    (final: prev: {
      #      nvchad = inputs.nix4nvchad.packages."${pkgs.system}".nvchad;
      #    })
      #  ];
      #};
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      homeConfigurations."jaysa" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
          ./home.nix 
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
	      extraSpecialArgs = {
          inherit self inputs;
	      };

      };
    };
}
