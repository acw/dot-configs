{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    cargo-edit
    cargo-fuzz
    cargo-machete
    cargo-tarpaulin
    libiconv
    mold
    darwin.apple_sdk.frameworks.CoreFoundation
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" ];
      targets = [ "aarch64-apple-darwin" "wasm32-wasi" "wasm32-unknown-unknown" ];
    })
  ];

  home.file = {
    ".cargo/config.toml".text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = 'clang'
      rustflags = ["-C", "link_arg=--ld-path=${pkgs.mold}/bin/mold"]

      [target.aarch64-apple-darwin]
      rustflags = [
        "-C", "link_arg=-L${lib.makeLibraryPath [ pkgs.libiconv ]}",
      ]
      linker = "/usr/bin/ld"

      [target.aarch64-unknown-linux-gnu]
      linker = 'aarch64-linux-gnu-gcc'
      runner = 'qemu-aarch64 -L /usr/aarch64-linux-gnu -E LD_LIBRARY_PATH=/usr/aarch64-linux-gnu/lib -E WASMTIME_TEST_NO_HOG_MEMORY=1'
      rustflags = ["-C", "link_arg=--ld-path=${pkgs.mold}/bin/mold"]

      [target.riscv64gc-unknown-linux-gnu]
      linker = 'riscv64-linux-gnu-gcc'
      runner = 'qemu-riscv64 -cpu rv64,v=true,vlen=256,vext_spec=v1.0,zba=true,zbb=true,zbc=true,zbs=true,zbkb=true -L /usr/riscv64-linux-gnu -E LD_LIBRARY_PATH=/usr/riscv64-linux-gnu/lib -E WASMTIME_TEST_NO_HOG_MEMORY=1'

      [target.s390x-unknown-linux-gnu]
      linker = 's390x-linux-gnu-gcc'
      runner = 'qemu-s390x -L /usr/s390x-linux-gnu -E LD_LIBRARY_PATH=/usr/s390x-linux-gnu/lib -E WASMTIME_TEST_NO_HOG_MEMORY=1'
    '';
  };

  programs.zsh.envExtra = ''
    export PATH="$PATH:${config.home.homeDirectory}/.cargo/bin"
  '';

}
