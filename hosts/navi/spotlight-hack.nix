{ ... }:

{
  system.activationScripts.copyNixApps.text = ''
    set -euo pipefail

    DEST="/Applications/Nix"
    SRC_SYS="/Applications/Nix Apps"
    SRC_HM="$HOME/Applications/Home Manager Apps"
    LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

    mkdir -p "$DEST"

    if [ -d "$SRC_SYS" ]; then
      /usr/bin/rsync -a --include='*/' --include='*.app/***' --exclude='*' "$SRC_SYS/" "$DEST/"
    fi

    if [ -d "$SRC_HM" ]; then
      /usr/bin/rsync -a --include='*/' --include='*.app/***' --exclude='*' "$SRC_HM/" "$DEST/"
    fi

    /usr/bin/mdimport "$DEST" || true

    # Register any apps we just synced (no tricky quoting)
    /usr/bin/find "$DEST" -maxdepth 1 -type d -name '*.app' -exec "$LSREG" -f {} +
  '';

  launchd.user.agents."nix-apps-sync" = {
    script = ''
      set -euo pipefail

      DEST="/Applications/Nix"
      SRC_SYS="/Applications/Nix Apps"
      SRC_HM="$HOME/Applications/Home Manager Apps"
      LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

      mkdir -p "$DEST"

      if [ -d "$SRC_SYS" ]; then
        /usr/bin/rsync -a --include='*/' --include='*.app/***' --exclude='*' "$SRC_SYS/" "$DEST/"
      fi

      if [ -d "$SRC_HM" ]; then
        /usr/bin/rsync -a --include='*/' --include='*.app/***' --exclude='*' "$SRC_HM/" "$DEST/"
      fi

      /usr/bin/mdimport "$DEST" || true
      /usr/bin/find "$DEST" -maxdepth 1 -type d -name '*.app' -exec "$LSREG" -f {} +
    '';

    serviceConfig = {
      RunAtLoad = true;

      WatchPaths = [ "/Applications/Nix Apps" ];

      StartInterval = 60; 

      StandardOutPath = "/tmp/nix-apps-sync.out";
      StandardErrorPath = "/tmp/nix-apps-sync.err";
    };
  };
}
