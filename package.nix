# SPDX-License-Identifier: MIT
{
  lib,
  installer,
  writeShellApplication,
  wineWow64Packages,
  winetricks,
  coreutils,
  gnugrep,
}:

let
  wine = wineWow64Packages.full;
in
writeShellApplication {
  name = "kakaotalk";
  derivationArgs.version = "0.1.0";
  runtimeInputs = [
    wine
    winetricks
    coreutils
    gnugrep
  ];
  meta = {
    description = "Unofficial KakaoTalk launcher for Wine";
    # The launcher source is MIT-licensed; the package depends on proprietary KakaoTalk.
    license = lib.licenses.unfree;
    hydraPlatforms = [ ];
  };
  text = ''
    install_mode=false
    if [[ "''${1:-}" == install ]]; then
      install_mode=true
      shift
    fi

    usage() {
      if [[ "$install_mode" != true ]]; then
        printf '%s\n' "Usage: $0 --no"
      fi
      printf '%s\n' "Usage: $0 install --no"
    }

    if (( $# > 1 )); then
      usage >&2
      exit 1
    fi

    case "''${1:-}" in
      --yes)
        printf '%s\n' '이 런처는 카카오톡PC의 공식적인 실행 경로가 아닙니다. --yes 가 넘어왔으므로 이 사실을 인지한 것으로 간주합니다.'
        printf '%s\n' 'This launcher is not an official way to run KakaoTalk for PC. Since --yes was provided, we assume you acknowledge this.'
        ;;
      ""|--no)
        printf '%s\n' '이 런처는 카카오톡PC의 공식적인 실행 경로가 아닙니다. 이것을 인지하였다면 --yes 인자를 넘기세요.' >&2
        printf '%s\n' 'This launcher is not an official way to run KakaoTalk for PC. If you acknowledge this, pass the --yes argument.' >&2
        exit 1
        ;;
      --help)
        usage
        exit 0
        ;;
      --version)
        printf '%s\n' '0.1.0'
        exit 0
        ;;
      *)
        usage >&2
        exit 1
        ;;
    esac

    default_prefix="''${XDG_DATA_HOME:-$HOME/.local/share}/kakaotalk/wine"
    if [[ -z "''${WINEPREFIX:-}" && -f "$default_prefix/system.reg" ]] &&
       grep -q '^#arch=win32$' "$default_prefix/system.reg"; then
      echo "Preserving existing 32-bit prefix; using $default_prefix-wow64 instead." >&2
      default_prefix="$default_prefix-wow64"
    fi
    export WINEPREFIX="''${WINEPREFIX:-$default_prefix}"
    export WINEARCH="''${WINEARCH:-win64}"
    if [[ "$WINEARCH" != win64 ]]; then
      echo 'This Wine WoW64 launcher requires WINEARCH=win64.' >&2
      exit 1
    fi
    if [[ -f "$WINEPREFIX/system.reg" ]] &&
       grep -q '^#arch=win32$' "$WINEPREFIX/system.reg"; then
      echo "Wine WoW64 cannot use the 32-bit prefix at $WINEPREFIX." >&2
      echo 'Choose a new absolute WINEPREFIX path to reinstall; the existing prefix is preserved.' >&2
      exit 1
    fi
    export WINEDLLOVERRIDES="mscoree,mshtml=''${WINEDLLOVERRIDES:+;$WINEDLLOVERRIDES};winemenubuilder.exe=d"
    # Winetricks cannot detect WoW64 through Nix's shell wrapper.
    # Keep the wrapper for execution and use the ELF binary for detection.
    export WINE="${wine}/bin/wine"
    export WINE64="$WINE"
    export WINESERVER="${wine}/bin/wineserver"
    export WINE_BIN="${wine}/bin/.wine"
    mkdir -p "$WINEPREFIX"
    if [[ "$WINEPREFIX" != /* ]]; then
      echo 'WINEPREFIX must be an absolute path.' >&2
      exit 1
    fi
    app="$WINEPREFIX/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe"
    if [[ "$WINEARCH" == win64 ]]; then
      app="$WINEPREFIX/drive_c/Program Files (x86)/Kakao/KakaoTalk/KakaoTalk.exe"
    fi
    if [[ "$install_mode" == true || ! -f "$app" ]]; then
      fonts="''${KAKAOTALK_FONTS-corefonts cjkfonts}"
      if [[ -n "$fonts" ]]; then
        read -r -a font_args <<< "$fonts"
        winetricks -q "''${font_args[@]}"
      fi
      wine "${installer}"
    else
      exec wine "$app"
    fi
  '';
}
