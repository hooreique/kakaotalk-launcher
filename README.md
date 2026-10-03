# kakaotalk-launcher

A Nix flake for running 32-bit KakaoTalk on x86_64 Linux with Wine WoW64.

## Getting started

Requires Nix with the `nix-command` and `flakes` experimental features enabled.

```sh
NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:hooreique/kakaotalk-launcher#kakaotalk -- --no
```

The first run opens the installer. After installation finishes, run the same command again to launch KakaoTalk.
`NIXPKGS_ALLOW_UNFREE=1` and `--impure` allow unfree packages.

To run the installer again:

```sh
NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:hooreique/kakaotalk-launcher#kakaotalk -- install --no
```

The default data directory is `${XDG_DATA_HOME:-$HOME/.local/share}/kakaotalk/wine`.

## Troubleshooting

- Due to a known issue, KakaoTalk may need to be launched twice to start successfully, even after installation.
- To quit, press `Ctrl+C` in the terminal used to launch it instead of clicking the window's X button. This has been more reliable in practice.

## Disclaimer

This is an unofficial launcher with no affiliation with Kakao. It comes with no guarantee that it will work. Use it at your own risk.

[MIT License](LICENSE) · [Development and maintenance guide](CONTRIBUTING.md)
