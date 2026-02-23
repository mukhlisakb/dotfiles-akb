{
  pkgs,
  hostname,
  username,
  ...
}:
let
  byHostname = ./hosts + "/${hostname}.nix";
  byUsername = ./hosts + "/${username}.nix";

  hostModule =
    if builtins.pathExists byHostname then
      byHostname
    else if builtins.pathExists byUsername then
      byUsername
    else
      ./hosts/derangga.nix;

  rustLibraryPath = pkgs.lib.makeLibraryPath [
    pkgs.libiconv
    pkgs.openssl_3
  ];

  rustCPath = pkgs.lib.makeSearchPath "include" [
    pkgs.libiconv
    pkgs.openssl_3
  ];

  rustPkgConfigPath =
    pkgs.lib.makeSearchPath "lib/pkgconfig" [ pkgs.openssl_3 ]
    + ":"
    + pkgs.lib.makeSearchPath "share/pkgconfig" [ pkgs.openssl_3 ];
in
{
  imports = [
    ./aerospace/config.nix
    ./catppuccin/config.nix
    ./lazyvim/config.nix
    ./starship/config.nix
    ./sketchybar/config.nix
    hostModule
  ];

  home.file."Library/Application Support/com.mitchellh.ghostty/config" = {
    source = ../others/ghostty/config;
  };

  home.file."Library/Application Support/com.mitchellh.ghostty/shaders" = {
    source = ../others/ghostty/shaders;
    recursive = true;
  };

  xdg.configFile."fastfetch/config.jsonc" = {
    text = ''
      {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
        "logo": {
          "source": "NixOS_small"
        },
        "modules": [
          "title",
          "separator",
          { "type": "custom", "key": "OS", "format": "Nix (nix-darwin)" },
          { "type": "os", "key": "Base OS" },
          "host",
          "kernel",
          "uptime",
          "packages",
          "shell",
          "display",
          "de",
          "wm",
          "wmtheme",
          "theme",
          "icons",
          "font",
          "cursor",
          "terminal",
          "terminalfont",
          "cpu",
          "gpu",
          "memory",
          "swap",
          "disk",
          "localip",
          "battery",
          "poweradapter",
          "locale",
          "break",
          "colors"
        ]
      }
    '';
  };

  home.file.".cargo/config.toml" = {
    text = ''
      [build]
      rustflags = [
        "-L", "native=${pkgs.libiconv}/lib",
        "-L", "native=${pkgs.openssl_3}/lib",
      ]

      [env]
      LIBRARY_PATH = { value = "${rustLibraryPath}", force = true }
      CPATH = { value = "${rustCPath}", force = true }
      PKG_CONFIG_PATH = { value = "${rustPkgConfigPath}", force = true }
      OPENSSL_DIR = { value = "${pkgs.openssl_3}", force = true }
    '';
  };

  home.packages = with pkgs; [
    dbeaver-bin
    nodejs_22
    flutter
    cocoapods
  ];

  home.sessionVariables = {
    ANDROID_HOME = "/Users/${username}/Library/Android/sdk";
    ANDROID_SDK_ROOT = "/Users/${username}/Library/Android/sdk";
    CHROME_EXECUTABLE = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
  };

  programs.bat = {
    enable = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "always";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.vscode = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };
}
