top@{ inputs, ... }: {
  imports = [ ./nixos ./home ];
  systems = [ "x86_64-linux" ];
  perSystem = perSystem@{ system, ... }: {
    config._module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            nvim = inputs.ide.nvim.${system}.standalone {
              plugins.lsp.servers = {
                bashls.enable = true;
                nushell.enable = true;
              };
            };
            scripts = (prev.buildEnv { name = "scripts"; paths = [ ./. ]; });
          })
        ];
      };
      stateVersion = "24.05";
    };
  };
}
