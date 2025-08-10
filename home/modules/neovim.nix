{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      git
      wl-clipboard
      xclip
    ];

    plugins = [ ];

    extraLuaConfig = builtins.readFile ./neovim/init.lua;
  };

  home.file.".config/nvim/lua/colors/pochi.lua".source = ./neovim/pochi.lua;
}