# SPDX-License-Identifier: MIT
{ lib, fetchurl }:

fetchurl {
  version = "0.1.0";
  url = "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe";
  hash = "sha256-1jwQoVMKr+8fSFQ2qk7JMyKg7h4U6jL5cRkiLVWczZY=";

  meta = {
    description = "Proprietary KakaoTalk for Windows installer";
    # This Nix expression is MIT-licensed; the downloaded software is not.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    hydraPlatforms = [ ];
  };
}
