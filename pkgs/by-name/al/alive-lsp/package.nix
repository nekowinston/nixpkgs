{
  lib,
  stdenvNoCC,
  makeWrapper,
  sbcl,
  sbclPackages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alive-lsp";
  inherit (sbclPackages.alive-lsp) version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  # as of 2025-12-04, alive-lsp only targets sbcl
  sbclEnv = sbcl.withPackages (ps: [ ps.alive-lsp ]);

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${finalAttrs.sbclEnv}/bin/sbcl $out/bin/alive-lsp \
      --add-flags '--eval "(require :asdf)"' \
      --add-flags '--eval "(asdf:load-system :alive-lsp)"' \
      --add-flags '--eval "(alive/server:start)"'
  '';

  meta = {
    description = "Language Server Protocol implementation for use with the Alive extension";
    homepage = "https://github.com/nobody-famous/alive-lsp/";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.nekowinston ];
  };
})
