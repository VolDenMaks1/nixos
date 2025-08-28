{
  inputs = {
    # Nixpkgs, основная коллекция пакетов
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05"; 
    
    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        
        home-manager.nixosModules.home-manager
        
        {
          home-manager.users.vadyanik = import ./home.nix;
        }
      ];
    };
  };
}
