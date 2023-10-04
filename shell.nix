{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  }
}:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    includeNDK = true;
  };
in
(pkgs.buildFHSUserEnvBubblewrap {
  name = "atomic-env";

  targetPkgs = pkgs: (with pkgs; [
    androidComposition.androidsdk
    cargo
    glib
    gtk3
    jdk
    libsoup_3
    openssl_3
    pkg-config
    rustfmt
    webkitgtk_4_1
  ]);

  profile = ''
    export ANDROID_HOME=${androidComposition.androidsdk}/libexec/android-sdk
    export NDK_HOME=$ANDROID_HOME/ndk-bundle
  '';

  runScript = "fish";

}).env
