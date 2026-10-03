# Contributing and maintenance

## Development environment

```sh
NIXPKGS_ALLOW_UNFREE=1 nix develop --impure .
```

NixOS `allowUnfree` settings do not automatically apply to this flake.

For Wine tests, use a separate absolute `WINEPREFIX` with `WINEARCH=win64`.
Set `KAKAOTALK_FONTS=''` to skip font installation.

If winetricks fails to detect WoW64 or reports an empty `%AppData%`, check `WINE_BIN`:
it must point to the ELF binary behind Nix's Wine wrapper.

## Updating the installer

If the installer hash changes, verify the download from the URL in `installer.nix` before updating `hash`.

## Validation

```sh
NIXPKGS_ALLOW_UNFREE=1 nix build --impure . --no-link
NIXPKGS_ALLOW_UNFREE=1 nix flake check --impure --no-build
```

For launcher changes, check unfree package evaluation, argument handling, installation and launch,
and preservation of existing Wine prefixes.

Font downloads, GUI rendering, Korean input, login, and messaging remain unverified.

## Documentation

Keep README limited to essential getting-started instructions and the disclaimer.
Keep CONTRIBUTING concise and easy to maintain: include important guidance and omit excessive detail or information readers can reasonably infer.

## License and references

Project source is covered by the [MIT License](LICENSE). External software retains its own licenses.

Initial implementation reference: [Install kakaotalk with nix by Riey](https://gist.github.com/Riey/11a06d326bcc41e33d4145fc8ce44bd8).
