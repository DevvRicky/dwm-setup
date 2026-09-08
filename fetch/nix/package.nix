{
  lib,
  stdenv,
  makeWrapper,
  fastfetch,
  # linux-only
  pciutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fetch";
  version = lib.fileContents ../VERSION;
  __structuredAttrs = true;
  strictDeps = true;

  src = lib.cleanSource ../.;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/fetch \
    --prefix PATH : ${
      lib.makeBinPath ([ fastfetch ] ++ lib.optionals stdenv.hostPlatform.isLinux [ pciutils ])
    }
  '';

  meta = {
    description = "Animated 3D fetch tool that renders your distro logo as a spinning bas-relief";
    homepage = "https://github.com/areofyl/fetch";
    changelog = "https://github.com/areofyl/fetch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ghastrum ];
    mainProgram = "fetch";
    platforms = lib.platforms.unix;
  };
})
