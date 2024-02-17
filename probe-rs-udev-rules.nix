{ stdenv, ... }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.android-udev-rules ];

stdenv.mkDerivation {
  pname = "android-udev-rules";
  version = "20231207";

  src = ./probe-rs;

  installPhase = ''
    runHook preInstall
    install -D 69-probe-rs.rules $out/lib/udev/rules.d/69-probe-rs.rules
    runHook postInstall
  '';
}
