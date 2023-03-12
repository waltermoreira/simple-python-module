{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          foo = pkgs.python310Packages.buildPythonPackage {
            name = "foo";
            src = ./.; # change here to fetchGit { ... }
            format = "other";
            installPhase = ''
              mkdir -p $out/lib/python3.10/site-packages
              cp foo.py $out/lib/python3.10/site-packages
            '';
          };
          py = pkgs.python310.withPackages (ps: [ foo ]);
        in
        {
          packages.default = py;
          packages.py = py;
        }
      );
}
