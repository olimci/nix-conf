{ pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;

    settings = {
      paste_actions = "quote-urls-at-prompt,confirm";
      strip_trailing_spaces = "smart";
      enable_audio_bell = "no";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{index}";
      tab_bar_min_tabs = "0";
      shell = ".";
      editor = "nvim";
      shell_integration = "enabled";

      font_family = ''family="JetBrainsMono Nerd Font Mono"'';
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "12.0";
      force_ltr = "yes";
      disable_ligatures = "never";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      macos_hide_from_tasks = "yes";
      macos_quit_when_last_window_closed = "no";
    };

    keybindings = {
      "cmd+shift+t" = "new_tab_with_cwd";
      "cmd+shift+n" = "new_os_window_with_cwd";
      "cmd+enter" = "new_window";
      "cmd+shift+enter" = "new_os_window";
    };

    extraConfig = ''
      include theme.conf
    '';
  };

  home.file.".config/kitty/theme.conf".source = ./kitty/mocha.conf;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
}
