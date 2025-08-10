{
  programs.go = {
    enable = true;
    goPath = "~/go";  # no need for ${config...}
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];
}
