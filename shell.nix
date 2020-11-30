{ moz_overlay ? import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz)
, nixpkgs ? import <nixpkgs> {
    overlays = [ moz_overlay ];
  }
}:

with nixpkgs.latest.rustChannels;
with nixpkgs;
with llvmPackages_latest;

let
  channel = rustChannelOf { date = "2020-08-20"; channel = "nightly"; };
  rust = channel.rust.override {
    targets = [ "wasm32-unknown-unknown" ];
  };
in
  stdenv.mkDerivation {
    name = "substrate-nix-shell";
    buildInputs = [ rust ];
    LIBCLANG_PATH = "${libclang}/lib";
    PROTOC = "${protobuf}/bin/protoc";
  }
