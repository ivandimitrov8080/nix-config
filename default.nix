{ inputs, ... }:
{
  imports = [ ./src ];
  systems = [ "x86_64-linux" ];
  flake.stateVersion = "24.11";
  perSystem =
    {
      system,
      pkgs,
      config,
      ...
    }:
    {
      config = {
        _module.args = {
          pkgs = import inputs.nixpkgs { inherit system; };
        };
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (ghc.withPackages (hkgs: with hkgs; [ turtle libnix ]))
            (config.packages.nvim.extend {
              plugins = {
                lsp.servers = {
                  hls = {
                    enable = true;
                    installGhc = false;
                  };
                };
              };
            })
          ];
        };
      };
    };
}
