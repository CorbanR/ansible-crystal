{
  description = "ansible-crystal";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs =
          if (system == "aarch64-darwin") then
            # Right now just use x86_64 and let the m1 rosetta framework handle the rest
            # pynacl has not been updated to work with aarch64-darwin
            nixpkgs.legacyPackages.x86_64-darwin
          else
            nixpkgs.legacyPackages.${system};

        isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
        isx86_64 = pkgs.stdenv.hostPlatform.isx86_64;
        inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices ApplicationServices Security;

        darwin_packages = [CoreServices ApplicationServices Security];

        # Python virtualenv
        pythonPackages = pkgs.python3Packages;
        venvDir = "./.venv";
        libxml2DevPath = "${pkgs.libxml2.dev}/include/libxml2/:";
      in
        {
          devShell = pkgs.mkShell rec {
            buildInputs = [
              pkgs.bash-completion
              pkgs.libsodium
              pkgs.libxslt
              pkgs.zlib
              pkgs.libxml2
              pkgs.git
              pythonPackages.python
              pythonPackages.yamllint
            ] ++ pkgs.lib.optional isDarwin darwin_packages;

            C_INCLUDE_PATH = "${pkgs.libxml2.dev}/include/libxml2/";

            shellHook = ''
              # Needed for testing crystal right now, as it only supports x86_64
              if [ $(uname -s) == "Darwin" ]; then
                export DOCKER_DEFAULT_PLATFORM=linux/amd64
                # This is to override the default images used by molecule(ansible testing)
                export CENTOS_STREAM_EIGHT_IMAGE=quay.io/centos/centos@sha256:42195c1371c1373da4420dfd0bbae11ac5617fc5571e6549ce95f59a994ff0ab
                export UBUNTU_FOCAL_IMAGE=ubuntu@sha256:3246518d9735254519e1b2ff35f95686e4a5011c90c85344c1f38df7bae9dd37
                export UBUNTU_JAMMY_IMAGE=ubuntu@sha256:b060fffe8e1561c9c3e6dea6db487b900100fc26830b9ea2ec966c151ab4c020
              fi
              # For python virtualenv
              SOURCE_DATE_EPOCH=$(date +%s)
              if [ -d "${venvDir}" ]; then
                echo "Skipping venv creation, '${venvDir}' already exists"
              else
                echo "Creating new venv environment in path: '${venvDir}'"
                ${pythonPackages.python.interpreter} -m venv "${venvDir}"
              fi
              PYTHONPATH=$PWD/${venvDir}/${pythonPackages.python.sitePackages}/:$PYTHONPATH
              source "${venvDir}/bin/activate"

              # Add additional folders to to XDG_DATA_DIRS if they exists, which will get sourced by bash-completion
              for p in ''${buildInputs}; do
                if [ -d "$p/share/bash-completion" ]; then
                  XDG_DATA_DIRS="$XDG_DATA_DIRS:$p/share"
                fi
              done

              source ${pkgs.bash-completion}/etc/profile.d/bash_completion.sh
            '';
          };
        }
      );
}
