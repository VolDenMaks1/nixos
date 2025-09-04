{ config, pkgs, ... }:

# ----------------------------------------------------------------------------
# NixOS configuration for host: nixos
# Style: compact, grouped by domains, with alphabetized lists where helpful
# Notes:
#  - Apps are system-wide via environment.systemPackages
#  - Home Manager is used only for per-user dotfiles/shell/git/starship/fastfetch
#  - NVIDIA + GNOME on Wayland
# ----------------------------------------------------------------------------
{
  #############################################################################
  # Imports & Global Nix settings
  #############################################################################
  imports = [
    ./hardware-configuration.nix
#    <home-manager/nixos>
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  #############################################################################
  # Boot & Power
  #############################################################################
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    resumeDevice = "/dev/disk/by-uuid/1dd56c6c-76d8-4891-8de8-d7952760de05";
  };

  #############################################################################
  # Locale, Time & Keyboard
  #############################################################################
  time.timeZone = "Europe/Kyiv";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  #############################################################################
  # Hostname & Networking
  #############################################################################
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  #############################################################################
  # Filesystems & Swap
  #############################################################################
  swapDevices = [
    { device = "/dev/disk/by-uuid/1dd56c6c-76d8-4891-8de8-d7952760de05"; }
  ];

  #############################################################################
  # Graphical stack (GNOME + NVIDIA + PipeWire)
  #############################################################################
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Remove GNOME apps you don't want
  environment.gnome.excludePackages = with pkgs; [
    evince
    geary
    gnome-browser-connector
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-contacts
    gnome-connections
    gnome-maps
    gnome-music
    gnome-terminal
    gnome-text-editor
    gnome-tour
    gnome-weather
    xterm
  ];

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # NVIDIA specifics
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;           # Use open kernel module (recommended for RTX)
      nvidiaSettings = true; # nvidia-settings utility
      powerManagement.enable = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  #############################################################################
  # Printing, Flatpak, Steam, OBS
  #############################################################################
  services.printing.enable = false;
  services.flatpak.enable  = true;

  programs = {
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ ];
    };
    steam.enable = true;
  };

  #############################################################################
  # Users
  #############################################################################
  users.users.vadyanik = {
    isNormalUser = true;
    description = "vadyanik";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ]; # keep empty (we install system-wide)
  };

  #############################################################################
  # System-wide Packages & Fonts
  #############################################################################
  environment.systemPackages = with pkgs; [
    # Core tooling
    bat
    blender
    bottom
    btop
    eza
    fastfetch
    git
    gdu
    gnome-extension-manager
    gnome-tweaks
    ghostty
    home-manager
    kdePackages.kate
    lazygit
    librewolf
    neovim
    nodejs
    python3
    ripgrep
    telegram-desktop
    tmux
    tor-browser
    tree-sitter
    unzip
    ayugram-desktop
    firefox
    teams-for-linux
    xclip
    zoom-us
    mullvad-vpn
  ];

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts._0xproto
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  #############################################################################
  # Services
  #############################################################################
  services.mullvad-vpn.enable = true;

  #############################################################################
  # Home Manager (dotfiles only)
  #############################################################################
  home-manager = {
    users.vadyanik = { pkgs, ... }: {
      home = {
        username = "vadyanik";
        homeDirectory = "/home/vadyanik";
        stateVersion = "25.05"; # HM state version

        # Files, env, etc.
        file = {
          # ".screenrc".source = ./dotfiles/screenrc;
        };
        sessionVariables = { EDITOR = "nvim"; };
      };

      programs = {
        # Prompt & shell
        bash = {
          enable = true;
          shellAliases = {
            c    = "clear";
            h    = "history";
            l    = "eza -lah";
            ls   = "eza";
            top  = "btop";
            tree = "eza --tree --git-ignore";
            clear = "clear && fastfetch";
          };
          initExtra = ''
            eval "$(starship init bash)"
            fastfetch
          '';
        };

        starship.enable = true;

        # Git identity
        git = {
          enable = true;
          userName  = "vadyanik";
          userEmail = "omletgamer100@gmail.com";
          extraConfig.init.defaultBranch = "main";
        };

        # Fastfetch splash
        fastfetch = {
          enable = true;
          settings = {
            logo.source = "nixos_small";
            modules = [ "os" "packages" "de" "cpu" "gpu" "memory" "swap" "disk" ];
          };
        };

        home-manager.enable = true;
      };

      # No user-scoped packages; all apps are system-wide.
      home.packages = with pkgs; [ ];
    };
  };

  #############################################################################
  # System State Version
  #############################################################################
  system.stateVersion = "25.05";
}

