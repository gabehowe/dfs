{
  config,
  pkgs,
  inputs,
  ...
}:
{
  config.home.packages = with pkgs; [
    ## desktop apps
    discord
    obs-studio
    signal-desktop
    vlc
    tree
    jetbrains-toolbox
    spotify
    #    modrinth-app
    zathuraPkgs.zathura_pdf_mupdf

    ## prog langs + prog lang utils
    (texliveMedium.withPackages (
      ps: with ps; [
        latexmk
        texcount
        collection-latexextra
        collection-bibtexextra
        collection-latexrecommended
        biblatex-mla
        spie
      ]
    ))
    luarocks
    lua5_1
    cargo
    (python313.withPackages (
      ps: with ps; [
        numpy
        pandas
        requests
        pynvim
        sympy
        wand
        scipy
        matplotlib
        openpyxl
        lark
      ]
    ))
    rustc
    clippy
    gradle_9
    typst
    nix-search
    nix-tree
    uv

    ## utils
    dust # du alternative
    htmlq
    pinentry-curses
    gnupg
    pandoc
    ffmpeg
    ripdrag
    ripgrep
    imagemagick
    bat
    xclip
    pkg-config
    jq
    nmap
    viu
    direnv
    freerdp
    netcat # network util
    bluetui # bluetooth util
    dig # dns util
    ack
    tcpdump
    tmux
    unison
    gcc
    usbutils
    pax
    socat
    inotify-tools
    gnumake
    tree-sitter
    poppler-utils
    file-rename
    git-lfs
    parted
    dmidecode
    inkscape
    wl-clipboard
  ];
}
