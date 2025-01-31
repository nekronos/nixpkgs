{
  fetchFromGitHub,
  lib,
  rustPlatform,
  git,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  openssl,
  cacert,
}:

rustPlatform.buildRustPackage rec {
  pname = "helix";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "helix-editor";
    repo = "helix";
    rev = "025719c1d82fd32a82d8d8a4a138842ed92480c1";
    sha256 = "vLDweuBMu8fOyo9YMiV/1p9gxH5/OVm8zKRkGpbcuUA=";
  };

  cargoHash = "sha256-4/L0kwu1mvyipoKBSz+og4bM8c3rADNshhENqTbt+Z4=";

  nativeBuildInputs = [
    git
    openssl
    cacert
    installShellFiles
  ];

  env.HELIX_DEFAULT_RUNTIME = "${placeholder "out"}/lib/runtime";

  postInstall = ''
    # not needed at runtime
    rm -r runtime/grammars/sources

    mkdir -p $out/lib
    cp -r runtime $out/lib
    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/hx";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Post-modern modal text editor";
    homepage = "https://helix-editor.com";
    changelog = "https://github.com/helix-editor/helix/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "hx";
    maintainers = with lib.maintainers; [
      danth
      yusdacra
      zowoq
    ];
  };
}
