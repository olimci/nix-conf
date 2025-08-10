{ ... }:

{
  system.activationScripts.copyNixApps.text = ''
    set -euo pipefail

    SRC_SYS="/Applications/Nix Apps"
    DEST_SYS="/Applications/Nix"

    SRC_HM="$HOME/Applications/Home Manager Apps"
    DEST_HM="$HOME/Applications/Home Manager"

    LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

    rm -rf "$DEST_SYS" "$DEST_HM"
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
}
