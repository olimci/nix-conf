{
  programs.go = {
    enable = true;
    # optional: set a custom GOPATH
    goPath = "${config.home.homeDirectory}/go";
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];
}
