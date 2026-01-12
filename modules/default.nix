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

  home.packages = with pkgs; [
    dbeaver-bin
  ];

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
