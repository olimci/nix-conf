{ ... }:

{
  # One-time sync at rebuild
  system.activationScripts.copyNixApps.text = ''
    set -euo pipefail

    SRC_SYS="/Applications/Nix Apps"
    DEST_SYS="/Applications/Nix"

    SRC_HM="$HOME/Applications/Home Manager Apps"
    DEST_HM="$HOME/Applications/Home Manager"

    LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

    mkdir -p "$DEST_SYS" "$DEST_HM"

    # Copy (not link) .app bundles from system-level Nix Apps
    if [ -d "$SRC_SYS" ]; then
      /usr/bin/rsync -aL --include='*/' --include='*.app/***' --exclude='*' "$SRC_SYS/" "$DEST_SYS/"
    fi

    # Copy (not link) .app bundles from Home Manager Apps into ~/Applications/Home Manager
    if [ -d "$SRC_HM" ]; then
      /usr/bin/rsync -aL --include='*/' --include='*.app/***' --exclude='*' "$SRC_HM/" "$DEST_HM/"
    fi

    /usr/bin/mdimport "$DEST_SYS" || true
    /usr/bin/mdimport "$DEST_HM" || true

    /usr/bin/find "$DEST_SYS" -maxdepth 1 -type d -name '*.app' -exec "$LSREG" -f {} +
    /usr/bin/find "$DEST_HM" -maxdepth 1 -type d -name '*.app' -exec "$LSREG" -f {} +
  '';

  # Keep things in sync when apps change / new HM generation happens
  launchd.user.agents."nix-apps-sync" = {
    script = ''
      set -euo pipefail

      SRC_SYS="/Applications/Nix Apps"
      DEST_SYS="/Applications/Nix"

      SRC_HM="$HOME/Applications/Home Manager Apps"
      DEST_HM="$HOME/Applications/Home Manager"

      LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

      mkdir -p "$DEST_SYS" "$DEST_HM"

      if [ -d "$SRC_SYS" ]; then
        /usr/bin/rsync -aL --include='*/' --include='*.app/***' --exclude='*' "$SRC_SYS/" "$DEST_SYS/"
      fi

      if [ -d "$SRC_HM" ]; then
        /usr/bin/rsync -aL --include='*/' --include='*.app/***' --exclude='*' "$SRC_HM/" "$DEST_HM/"
      fi

      /usr/bin/mdimport "$DEST_SYS" || true
      /usr/bin/mdimport "$DEST_HM" || true

      /usr/bin/find "$DEST_SYS" -maxdepth 1 -type d -name '*.app' -exec "$LSREG" -f {} +
      /usr/bin/find "$DEST_HM" -maxdepth 1 -type d -name '*.app' -exec "$LSREG" -f {} +
    '';

    serviceConfig = {
      RunAtLoad = true;

      # launchd won't expand $HOME here; we rely on a timer for HM generations.
      WatchPaths = [ "/Applications/Nix Apps" ];

      # Poll to catch HM symlink target flips reliably (copy-only will dereference)
      StartInterval = 60; # seconds — adjust to taste

      StandardOutPath = "/tmp/nix-apps-sync.out";
      StandardErrorPath = "/tmp/nix-apps-sync.err";
    };
  };
}
