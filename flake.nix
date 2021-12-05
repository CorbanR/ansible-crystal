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
      in
        {
          devShell = pkgs.mkShell rec {
            buildInputs = [
              pkgs.bash-completion
              pkgs.libsodium
              pkgs.git
              pythonPackages.python
              pythonPackages.yamllint
            ] ++ pkgs.lib.optional isDarwin darwin_packages;

            shellHook = ''
              # Needed for testing crystal right now, as it only supports x86_64
              if [ $(uname -s) == "Darwin" ]; then
                export DOCKER_DEFAULT_PLATFORM=linux/amd64
                # This is to override the default images used by molecule(ansible testing)
                # These were required as upstream molecule is defaulting to system image (on my m1 that is arm64). Added custom create.yml
                # with platform option. This is needed until https://github.com/ansible-community/molecule-docker/pull/122 is merged.
                #export centos_eight_image=centos:centos8@sha256:a1801b843b1bfaf77c501e7a6d3f709401a1e0c83863037fa3aab063a7fdb9dc
                #export UBUNTU_FOCAL_IMAGE=ubuntu:20.04@sha256:7cc0576c7c0ec2384de5cbf245f41567e922aab1b075f3e8ad565f508032df17
                #export UBUNTU_BIONIC_IMAGE=ubuntu:18.04@sha256:fc0d6af5ab38dab33aa53643c4c4b312c6cd1f044c1a2229b2743b252b9689fc
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
