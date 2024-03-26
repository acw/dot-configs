{ pkgs ? import <nixpkgs> {} }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.12.0";

  src = pkgs.fetchCrate {
    inherit pname version;
    sha256 = "sha256-Bhef7PpYduPdB5KWUnnqAjV/lrJ6FwU5H8bsCs0k4C8=";
  };

  doCheck = false;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };
}
