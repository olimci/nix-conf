{ ... }:

let
  # If you know your primary user in nix-darwin, set this once and we’ll use it
  user = config.users.primaryUser.name or null;
  userHome =
    if user != null then config.users.users.${user}.home else "$HOME";
  hmApps = "${userHome}/Applications/Home Manager Apps";
in
{
  # Initial copy at rebuild (covers both sources)
  system.activationScripts.copyNixApps.text = ''
    set -euo pipefail

    DEST="/Applications/Nix"
    SRC_SYS="/Applications/Nix Apps"
    SRC_HM='${hmApps}'

    mkdir -p "$DEST"

    rsync -a --include='*/' --include='*.app/***' --exclude='*' --ignore-missing-args \
      "$SRC_SYS/" "$DEST/" 2>/dev/null || true

    rsync -a --include='*/' --include='*.app/***' --exclude='*' --ignore-missing-args \
      "$SRC_HM/" "$DEST/" 2>/dev/null || true

    /usr/bin/mdimport "$DEST" || true

    # Robust lsregister (only if there are .app bundles)
    if /usr/bin/find "$DEST" -maxdepth 1 -type d -name '*.app' -print -quit | grep -q .; then
      while IFS= read -r -d '' app; do
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app" || true
      done < <(/usr/bin/find "$DEST" -maxdepth 1 -type d -name '*.app' -print0)
    fi
  '';

  launchd.user.agents."nix-apps-sync" = {
    # Single script handles both sources
    script = ''
      set -euo pipefail

      DEST="/Applications/Nix"
      SRC_SYS="/Applications/Nix Apps"
      SRC_HM='${hmApps}'

      mkdir -p "$DEST"

      rsync -a --include='*/' --include='*.app/***' --exclude='*' --ignore-missing-args \
        "$SRC_SYS/" "$DEST/" 2>/dev/null || true

      rsync -a --include='*/' --include='*.app/***' --exclude='*' --ignore-missing-args \
        "$SRC_HM/" "$DEST/" 2>/dev/null || true

      /usr/bin/mdimport "$DEST" || true

      if /usr/bin/find "$DEST" -maxdepth 1 -type d -name '*.app' -print -quit | grep -q .; then
        while IFS= read -r -d '' app; do
          /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app" || true
        done < <(/usr/bin/find "$DEST" -maxdepth 1 -type d -name '*.app' -print0)
      fi
    '';

    serviceConfig = {
      RunAtLoad = true;

      # Watch both app roots. IMPORTANT: Use an absolute home path here.
      # If you can't/don't want to resolve the home path in Nix, also keep StartInterval below.
      WatchPaths = [
        "/Applications/Nix Apps"
        # This resolves to an absolute path via nix-darwin's users config:
        "${userHome}/Applications/Home Manager Apps"
      ];

      # Safety net: also poll occasionally to catch HM symlink flips that
      # don't always fire WatchPaths (e.g. if only the symlink target changes).
      StartInterval = 60; # seconds (tweak if you want less/more frequent)

      StandardOutPath = "/tmp/nix-apps-sync.out";
      StandardErrorPath = "/tmp/nix-apps-sync.err";
      # KeepAlive = true;  # optional, not usually needed with WatchPaths+StartInterval
    };
  };
}
