{ ... }:

{
  # initial copy at rebuild (unchanged)
  system.activationScripts.copyNixApps.text = ''
    set -euo pipefail
    SRC="/Applications/Nix Apps"
    DEST="/Applications/Nix"
    mkdir -p "$DEST"
    if [ -d "$SRC" ]; then
      /usr/bin/rsync -a --include='*/' --include='*.app/***' --exclude='*' "$SRC/" "$DEST/"
    fi
    /usr/bin/mdimport "$DEST" || true
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$DEST"/*.app || true
  '';

  # user LaunchAgent (note the path and serviceConfig)
  launchd.user.agents."nix-apps-sync" = {
    # You can use script OR command; script is convenient for sh blocks
    script = ''
      /usr/bin/rsync -a --include='*/' --include='*.app/***' --exclude='*' "/Applications/Nix Apps/" "/Applications/Nix/" && \
      /usr/bin/mdimport "/Applications/Nix" && \
      /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /Applications/Nix/*.app
    '';

    serviceConfig = {
      RunAtLoad = true;
      WatchPaths = [ "/Applications/Nix Apps" ];
      StandardOutPath = "/tmp/nix-apps-sync.out";
      StandardErrorPath = "/tmp/nix-apps-sync.err";
      # KeepAlive = true;  # optional
    };
  };
}
