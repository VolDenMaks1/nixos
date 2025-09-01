{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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
  
  swapDevices = [
    { device = "/dev/disk/by-uuid/1dd56c6c-76d8-4891-8de8-d7952760de05"; }
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/1dd56c6c-76d8-4891-8de8-d7952760de05";

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    geary
    gnome-music
    gnome-contacts
    gnome-maps
    gnome-tour
    gnome-terminal
    gnome-weather
    gnome-calculator
    evince
    gnome-calendar
    gnome-connections
    gnome-characters
    gnome-browser-connector
    gnome-text-editor
    xterm
  ];

  services.flatpak.enable = true;


  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = false;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.vadyanik = {
    isNormalUser = true;
    description = "vadyanik";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  # Включаем поддержку Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05"; 
}
