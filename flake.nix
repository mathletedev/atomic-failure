{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        libraries = with pkgs;[
          cairo
          dbus
          glib
          gtk3
          gdk-pixbuf
          openssl_3
          webkitgtk_4_1
        ];

        android = pkgs.androidenv.composeAndroidPackages {
          includeNDK = true;
        };

        packages = with pkgs; [
          android.androidsdk
          curl
          dbus
          glib
          gtk3
          jdk
          librsvg
          libsoup_3
          openssl_3
          pkg-config
          webkitgtk_4_1
          wget
        ];
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = packages;

          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
            export ANDROID_HOME=${android.androidsdk}/libexec/android-sdk
            export NDK_HOME=${android.androidsdk}/libexec/android-sdk/ndk-bundle
          '';
        };
      });
}
