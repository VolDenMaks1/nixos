{ config, pkgs, ... }:

{
  home.username = "vadyanik";
  home.homeDirectory = "/home/vadyanik";

  home.stateVersion = "25.05";

  # Добавляем ваши пакеты
  home.packages = with pkgs; [
    neovim
    ghostty
    fastfetch
    telegram-desktop
  ];

  # ...остальные настройки Home Manager...
  programs.home-manager.enable = true;
}
