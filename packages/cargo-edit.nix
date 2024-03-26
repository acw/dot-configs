{ pkgs ? import <nixpkgs> {} }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.12.2";

  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl
    openssl.dev
  ];

  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  src = pkgs.fetchCrate {
    inherit pname version;
    sha256 = "sha256-bNM+dpJt/Zfok4H74HdNjqar5xelpK4ckoMo9O+BcNk=";
  };

  doCheck = false;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };
}
