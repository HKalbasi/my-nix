# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, home-manager, unstable, nix-alien, config, ... }:
let
  praytimes = import ./praytimes.nix unstable;
  shmenu = import ./shmenu.nix unstable;
  personal = import ./personal.nix;
in
{
  imports =
    [
      home-manager.nixosModules.default
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloadero
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 5000 8000 8080 ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;

    layout = "us,ir";
    xkbOptions = "grp:alt_shift_toggle";
    desktopManager = {
      xterm.enable = false;
    };

    extraLayouts.fa = {
      description = "Standard farsi keyboard + !@#$";
      languages = [ "fa" ];
      symbolsFile = ./ir-hamid.xkb;
    };

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3lock #default i3 screen locker
        i3status
      ];
    };
  };



  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable compositor
  services.picom.enable = true;
  # Enable battery manager
  services.upower.enable = true;

  services.udev.packages = [
    (import ./probe-rs-udev-rules.nix pkgs)
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      firefox
      chromium
      #  thunderbird
    ];
  };
  home-manager.users.user = import ./home.nix { unstable = unstable; shmenu = shmenu; };

  # users.users.defaultUserShell = builtins.trace ''hello ${pkgs.fish}'' pkgs.fish;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  #nixpkgs.overlays = [ (import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz")) ];

  fonts.packages = with pkgs; [
    font-awesome
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  virtualisation.libvirtd.enable = true;
  virtualisation.vswitch.enable = true; # used for mininet

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    zellij
    alacritty
    yazi
    fish
    dconf
    gnome.nautilus
    gnome.eog
    gnome.gnome-system-monitor
    gnome.gnome-disk-utility
    copyq # clipboard manager
    appimage-run
    xkb-switch
    busybox
    ripgrep
    jq
    unrar
    wineWowPackages.full
    libva-utils

    # KVM virtualization
    qemu
    qemu_kvm
    qemu-utils
    bridge-utils
    libvirt
    virt-manager

    # Fun
    libsForQt5.marble
    numbat
    mininet
    stockfish
    mindustry
    steam-run
    deluged

    pavucontrol
    networkmanagerapplet
    arandr
    vlc
    libreoffice
    persepolis

    praytimes
    shmenu

    sfz

    nil
    nixpkgs-fmt

    nix-alien.packages.${system}.nix-alien

    git
    flameshot
    du-dust
    python3
    rustup
    evcxr
    probe-rs
    openocd
    deno
    nodejs_20
    geogebra
    inkscape
    #rust-bin.nightly.latest.default
    gcc
    stdenv.cc
    stdenv.cc.libc
    stdenv.cc.libc_dev
    pkg-config
    cmake
    gnumake
    libllvm
    hyperfine
    clang-tools
    gdb

    xray
    openvpn
    wireshark
    qv2ray

    vscode
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        ms-python.python
        ms-vscode-remote.remote-ssh
        vscode-icons-team.vscode-icons
        tomoki1207.pdf
        jnoortheen.nix-ide
        eamodio.gitlens
        esbenp.prettier-vscode
        vadimcn.vscode-lldb
        llvm-vs-code-extensions.vscode-clangd
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
        {
          name = "shopify-liquid";
          publisher = "sissel";
          version = "4.0.1";
          sha256 = "sha256-W4ZKGlc8MuyS46imasfPiIZlMDsnqwhdOUoKACv4DbQ=";
        }
        {
          name = "rust-analyzer";
          publisher = "rust-lang";
          version = "0.4.1876";
          sha256 = "sha256-sBMKZODhftekWGDvzrKvHWJQ4knefHLF5umzavC9lRE=";
        }
        {
          name = "vscode-drawio";
          publisher = "hediet";
          version = "1.6.6";
          sha256 = "sha256-SPcSnS7LnRL5gdiJIVsFaN7eccrUHSj9uQYIQZllm0M=";
        }
      ];
    })
  ];

  environment.shellAliases = {
    update = "sudo nixos-rebuild switch --flake .#main --impure";
    mscode = "${pkgs.vscode}/bin/code";
    code = "codium";
    nish = "nix-shell . --command fish";
  };

  programs.fish.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  programs.proxychains = personal.proxychains or { enable = false; };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
