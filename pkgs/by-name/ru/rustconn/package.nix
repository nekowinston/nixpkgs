{
  lib,
  rustPlatform,
  alsa-lib,
  fetchFromGitHub,
  freerdp,
  gtk4,
  libadwaita,
  libsecret,
  nix-update-script,
  openssl,
  pkg-config,
  versionCheckHook,
  vte-gtk4,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustconn";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "totoshko88";
    repo = "RustConn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7yFDCfdAgN7kHC+tEEzSCNvRB/uvOChg63wQjixsfVs=";
  };

  cargoHash = "sha256-kT5QpijQMSCACbG24WThQjXhpo3YY6pBjKVNInUftWM=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    gtk4
    libadwaita
    openssl
    vte-gtk4
  ];

  postInstall = ''
    chmod +x ./install-desktop.sh
    patchShebangs ./install-desktop.sh
    PREFIX=$out ./install-desktop.sh
  '';

  # only wrap the GUI binary
  dontWrapGApps = true;
  preFixup = ''
    wrapGApp $out/bin/rustconn \
      --prefix PATH : "${
        lib.makeBinPath [
          libsecret
          # shipping with external freerdp as the embedded client can struggle
          # with gnome-remote-desktop servers
          freerdp
        ]
      }"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern connection manager for Linux with GTK4/Wayland-native interface";
    homepage = "https://github.com/totoshko88/RustConn";
    changelog = "https://github.com/totoshko88/RustConn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nekowinston ];
    mainProgram = "rustconn";
    platforms = lib.platforms.linux;
  };
})
