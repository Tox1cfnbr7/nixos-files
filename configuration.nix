# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib, inputs, ... }:

let
  q = pkgs.kdePackages;

  silent = pkgs.stdenvNoCC.mkDerivation {
    pname = "sddm-silent-theme";
    version = "git";

    src = pkgs.fetchFromGitHub {
      owner = "uiriansan";
      repo = "SilentSDDM";
      rev = "main";
      hash = "sha256-TNGAElCnjIA4OzTtn0VuCk6pXKd92kBkz+5NjHLwbkM=";
    };

    propagatedBuildInputs = [
      q.qtsvg
      q.qtmultimedia
      q.qtvirtualkeyboard
      q.qtimageformats
      q.qt5compat
      q.qtdeclarative
    ];

    dontWrapQtApps = true;
    # Change this for diffrent themes can be found in /run/current-system/sw/share/sddm/themes/silent/configs/
    postPatch = ''
      sed -i 's|^ConfigFile=.*|ConfigFile=configs/catppuccin-macchiato.conf|' metadata.desktop
    '';

    installPhase = ''
      mkdir -p $out/share/sddm/themes/silent $out/share/fonts
      cp -r . $out/share/sddm/themes/silent/
      cp -r fonts/* $out/share/fonts/
    '';
  };

  qtPkgs = [
    q.qtsvg
    q.qtmultimedia
    q.qtvirtualkeyboard
    q.qtimageformats
    q.qt5compat
    q.qtdeclarative
  ];

  qmlPath    = lib.concatMapStringsSep ":" (p: "${p}/lib/qt-6/qml") qtPkgs;
  pluginPath = lib.concatMapStringsSep ":" (p: "${p}/lib/qt-6/plugins") qtPkgs;
  themeQml   = "${silent}/share/sddm/themes/silent/components";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Graphics
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  
  nixpkgs.config.allowUnfree = true;
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

fonts = {
  packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  fontconfig.defaultFonts = {
    monospace = [ "CaskaydiaCove Nerd Font Mono" ];
    sansSerif = [ "Noto Sans" ];
    serif = [ "Noto Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };
};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # For binaries that are unkown
  programs.nix-ld.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "ch";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.tox1c = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" "wireshark" ]; # Enable ‘sudo’ for the user. users.
     packages = with pkgs; [
       tree
     ];
   };

  users.users.tox1c.shell = pkgs.zsh;
  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };
  };

  virtualisation.docker.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.dconf.enable = true;
  programs.firefox.enable = true;
  programs.sway.enable = true;
  programs.sway.extraOptions = [ "--unsupported-gpu" ];
  programs.neovim.enable = true;
  programs.git.enable = true;
  programs.waybar.enable = false;
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
environment.systemPackages = with pkgs; [
  vim
  wget
  alacritty
  wmenu
  vscode
  file
  silent 
  exiftool
  discord
  spotify
  nwg-displays
  kdePackages.qtmultimedia
  obsidian
  proton-vpn
  burpsuite
  blueman
  ghidra
  wireshark
  tshark
  pavucontrol
  thunar
  zsh
  zip
  fastfetch
  duf
  eza
  fzf
  adw-gtk3
  papirus-icon-theme
  wlsunset
  glib
  keepassxc
  rofi
  bibata-cursors
  loupe
  gcc
  _7zz
  bat
  btop
  tree
  trash-cli
  hexedit
  imagemagick
  hwinfo
  parted
  nettools
  curl
  man-pages
  strace
  ltrace
  dunst
  brightnessctl
  fuzzel
  nwg-look
  clang
  gnumake
  binutils
  bison
  go
  lua
  nodejs      
  python3
  pipx
  ruby
  jdk
  rustup
  sqlite
  docker-compose
  gdb
  gef
  radare2
  checksec
  binwalk
  python3Packages.ropgadget
  nmap
  tcpdump
  traceroute
  whois
  bind          
  socat
  openvpn
  wireguard-tools
  freerdp
  remmina
  rpcbind
  krb5
  metasploit
  sqlmap
  nikto
  thc-hydra
  john
  hashcat
  hashid
  wfuzz
  feroxbuster
  whatweb
  enum4linux
  dnsenum
  evil-winrm
  seclists
  dmidecode
  unzip
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # ----------------------- SDDM Silent Theme Section -----------------------------------------
  systemd.services.display-manager.environment = {
    QML2_IMPORT_PATH = "${themeQml}:${qmlPath}";
    QML_IMPORT_PATH  = "${themeQml}:${qmlPath}";
    QT_PLUGIN_PATH   = pluginPath;
  };
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = q.sddm;
    theme = "silent";

    extraPackages = [ silent ] ++ qtPkgs;

    settings.General = {
      InputMethod = "qtvirtualkeyboard";
      GreeterEnvironment = lib.concatStringsSep "," [
        "QML2_IMPORT_PATH=${themeQml}:${qmlPath}"
        "QML_IMPORT_PATH=${themeQml}:${qmlPath}"
        "QT_PLUGIN_PATH=${pluginPath}"
        "QT_IM_MODULE=qtvirtualkeyboard"
      ];
    };
  };
  # -----------------------------------------------------------------------
  
  services.blueman.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

