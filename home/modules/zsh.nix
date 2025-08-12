{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      expireDuplicatesFirst = true;
      share = true;
    };

    oh-my-zsh.enable = false;

    initContent = ''
      export EDITOR="nvim"

      setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY
      setopt EXTENDED_GLOB NO_NOMATCH INTERACTIVE_COMMENTS

      bindkey -e
      zmodload zsh/complist
      autoload -Uz compinit && compinit -d ~/.cache/zcompdump

      eval "$(direnv hook zsh)"

      alias lsa="eza -lah --icons"
      alias ls="eza -a --icons"
      alias lg="lazygit"
      alias cat="bat --paging=never"
      alias grep="rg -n --hidden --smart-case"

      alias icat="kitty +kitten icat"
      alias kssh="kitty +kitten ssh"

      export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_COMPLETION_TRIGGER='**'
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./zsh/starship.toml;

  programs.fzf = { enable = true; enableZshIntegration = true; };
  programs.direnv = { enable = true; nix-direnv.enable = true; };
  programs.zoxide = { enable = true; enableZshIntegration = true; };

  home.packages = with pkgs; [ eza bat ripgrep fd lazygit ];
}
