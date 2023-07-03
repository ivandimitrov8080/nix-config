{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  system.stateVersion = "23.05";

  hardware = {
    pulseaudio.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  security = {
    polkit.enable = true;
  };

  time.timeZone = "Europe/Sofia";

  fonts.fonts = with pkgs; [nerdfonts];

  environment = {
    systemPackages = with pkgs; [
      alejandra
      binutils
      cmatrix
      gimp
      git
      glibc
      gnome.cheese
      gnumake
      grim
      home-manager
      jmtpfs
      libgccjit
      libmtp
      mako
      mlocate
      nodejs_20
      pinentry-qt
      rustup
      slurp
      tealdeer
      unzip
      vim
      vimPlugins.nvchad
      wayland
      wdisplays
      wget
      wl-clipboard
      xdg-user-dirs
      xdg-utils
      zbar
      zip
    ];
    variables = {
      EDITOR = "nvim";
    };
    shells = with pkgs; [zsh];
    etc = {
      "xdg/user-dirs.conf".text = ''
        enabled=True
      '';
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    sway.enable = true;
    zsh.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.ivand = {
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "mlocate"];
    };
    extraGroups = {
      mlocate = {};
    };
  };

  home-manager.users.ivand = {lib, ...}: {
    home = {
      stateVersion = "23.05";
      pointerCursor = {
        name = "Bibata-Modern-Amber";
        package = pkgs.bibata-cursors;
      };
    };
    programs = {
      home-manager = {
        enable = true;
      };
      git = {
        enable = true;
        userName = "Ivan Dimitrov";
        userEmail = "ivan@idimitrov.dev";
      };
      kitty = {
        enable = true;
        settings = {
          enable_tab_bar = false;
          background_opacity = "0.9";
        };
      };
      neovim = {
        enable = true;
        viAlias = true;
      };
      zsh = {
        enable = true;
        enableSyntaxHighlighting = true;
        enableAutosuggestions = true;
        completionInit = '''';
        history = {
          size = 1000;
          save = 1000;
          expireDuplicatesFirst = true;
        };
        plugins = [
          {
            name = "zsh-autoenv";
            src = "${pkgs.zsh-autoenv}/share/zsh-autoenv";
            file = "autoenv.plugin.zsh";
          }
          {
            name = "zsh-powerlevel10k";
            src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
            file = "powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
          }
        ];
        initExtra = ''
          source "$HOME/.p10k.zsh"
        '';
      };
    };
    xdg.configFile = {
      nvim = {
        source = pkgs.vimPlugins.nvchad;
        recursive = true;
      };
      "nvim/lua/custom" = {
        source = ./cfg/nvim/custom;
        recursive = true;
      };
      "sway/config" = {
        source = ./cfg/sway/config;
      };
      "user-dirs.dirs" = {
        source = pkgs.writeText "user-dirs.dirs" ''
          XDG_DESKTOP_DIR="$HOME/dt"
          XDG_DOCUMENTS_DIR="$HOME/doc"
          XDG_DOWNLOAD_DIR="$HOME/dl"
          XDG_MUSIC_DIR="$HOME/snd"
          XDG_PICTURES_DIR="$HOME/pic"
          XDG_PUBLICSHARE_DIR="$HOME/pub"
          XDG_TEMPLATES_DIR="$HOME/tp"
          XDG_VIDEOS_DIR="$HOME/vid"
        '';
      };
    };
    home.packages = with pkgs; [
      bemenu
      brave
      gopass
      gopass-jsonapi
      pavucontrol
    ];
  };
}
