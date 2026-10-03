# SPDX-License-Identifier: MIT
{
  description = "Unofficial KakaoTalk installer and launcher for Wine (x86_64 Linux)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      installer = pkgs.callPackage ./installer.nix { };
      launcher = pkgs.callPackage ./package.nix { inherit installer; };
    in
    {
      overlays.default = final: prev: {
        kakaotalk = final.callPackage ./package.nix {
          installer = final.callPackage ./installer.nix { };
        };
      };
      packages.${system} = {
        default = launcher;
        kakaotalk = launcher;
        inherit installer;
      };
      apps.${system}.default = {
        type = "app";
        program = "${launcher}/bin/kakaotalk";
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          launcher
          pkgs.wineWow64Packages.full
          pkgs.winetricks
        ];
      };
    };
}
