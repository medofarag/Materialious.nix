{
  description = "Materialious on Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        materialious = pkgs.appimageTools.wrapType2 rec {

          pname = "materialious";
          version = "1.18.7";

          src = pkgs.fetchurl {
            url = "https://github.com/Materialious/Materialious/releases/download/${version}/Materialious-linux-x86_64.AppImage";
            sha256 = "sha256:8f072ce8f88c722e03dd6d8cb68e0ac064bdb0c8725a267560b2182511893460";
          };

          extraInstallCommands =
            let
              contents = pkgs.appimageTools.extract { inherit pname version src; };
            in
            ''
              mkdir -p $out/share/applications/
              cp ${contents}/${pname}.desktop $out/share/applications/
              chmod 444 $out/share/applications/${pname}.desktop
              substituteInPlace $out/share/applications/${pname}.desktop \
                --replace 'Exec=AppRun' 'Exec=${pname}'
              cp -r ${contents}/usr/share/icons $out/share
            '';

        };
      in
      {
        packages = {
          inherit materialious;
          default = materialious;
        };
      }
    );
}
