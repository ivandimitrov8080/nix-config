toplevel@{
  inputs,
  withSystem,
  ...
}:
let
  system = "x86_64-linux";
  mods = toplevel.config.flake.nixosModules;
  inherit (toplevel.config.flake) hardwareConfigurations;
  essential = with mods; [
    grub
    base
    shell
    security
    wireless
  ];
  desktop = with mods; [
    sound
    wayland
    intranet
  ];
  configWithModules =
    {
      hardware ? {
        nixpkgs.hostPlatform = system;
      },
      modules,
      hostname ? "nixos",
    }:
    withSystem system (
      { inputs', pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs inputs';
        };
        modules = [
          hardware
          { networking.hostName = hostname; }
        ] ++ modules;
      }
    );
  novaConfig =
    mods:
    configWithModules {
      hardware = hardwareConfigurations.nova;
      modules = essential ++ desktop ++ mods;
      hostname = "nova";
    };
in
{
  flake.nixosConfigurations = {
    nova = novaConfig [ mods.ivand ];
    nova-gaming = novaConfig (
      with mods;
      [
        ivand
        gaming
      ]
    );
    nova-ai = novaConfig (
      with mods;
      [
        ivand
        ai
      ]
    );
    vps = configWithModules {
      modules = with mods; [
        base
        shell
        security
        vps
        mailserver
        nginx
        wireguard-output
        anonymous-dns
        firewall
        rest
      ];
    };
  };
}
