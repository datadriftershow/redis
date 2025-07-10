{
  description = "A development shell for Redis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      llvm = pkgs.llvmPackages_17;
    in pkgs.mkShell {
      buildInputs = with pkgs; [
        llvm.stdenv.cc
        llvm.lld
        llvm.libcxx
        openssl
        zlib
        libbsd
        libaio
        libunwind
        systemd
      ];

      packages = with pkgs; [
        llvm.clang-tools
        python3
        pkg-config
        util-linux
        findutils
        gnused
        gawk
        file
        compiledb
        neovim
      ];

      shellHook = ''
        # These flags are exported for the C++ compiler and the linker
        export CC="clang"
        export CXX="clang++"
        export sysroot="${pkgs.linuxHeaders}"
        export CFLAGS="--sysroot=$sysroot"
        export CXXFLAGS="-stdlib=libc++"
        export LDFLAGS="-fuse-ld=lld"
        export SHELL="${pkgs.bash}/bin/bash"
        echo "--- Redis Development Shell ---"
        echo "Toolchain: clang + libc++ + lld"
      '';
    };
  };
}
