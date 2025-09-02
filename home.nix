{ config, pkgs, ... }:

{
  home.username = "vadyanik";
  home.homeDirectory = "/home/vadyanik";
  
  home.stateVersion = "25.05"; # не трогай без необходимости

  fonts.fontconfig.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  # Список пакетов пользователя
  home.packages = with pkgs; [
    neovim
    librewolf
    ghostty
    telegram-desktop
    git
    kdePackages.kate
    tor-browser
    tree-sitter
    xclip
    ripgrep
    lazygit
    gdu
    bottom
    python3
    nodejs
    zoom-us
    tmux
    fastfetch
    bat
    eza
    btop
    unzip
    gnome-extension-manager
    gnome-tweaks
    firefox
    teams-for-linux

    # fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts._0xproto
  ];

  programs.fastfetch = {
    enable = true;

    settings = {
      logo.source = "nixos_small";
      modules = [
        "os"
        "packages"
        "de"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
      ];
    };
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      l = "eza -lah";
      ls = "eza";
      tree = "eza --tree --git-ignore";

      top = "btop";

      c = "clear";
      h = "history";
      clear = "clear && fastfetch";
    };

    initExtra = ''
    eval "$(starship init bash)"

    fastfetch
    '';
  };

  home.file = {
    # ".screenrc".source = ./dotfiles/screenrc;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "vadyanik";
    userEmail = "omletgamer100@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };


  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };
  
  programs.home-manager.enable = true;
}

