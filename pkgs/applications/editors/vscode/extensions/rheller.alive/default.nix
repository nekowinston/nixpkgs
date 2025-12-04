{
  lib,
  vscode-utils,
  alive-lsp,
  jq,
  moreutils,
}:
# TODO:
# the package still needs to be patched in order to work on Nix,
# either here or upstream
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "rheller";
    name = "alive";
    version = "0.6.3";
    hash = "";
  };

  postInstall = ''
    cd "$out/$installPrefix"
  '';

  meta = {
    description = "Average Lisp VSCode Environment";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=rheller.alive";
    homepage = "https://github.com/nobody-famous/alive";
    license = lib.licenses.unlicense;
  };
}
