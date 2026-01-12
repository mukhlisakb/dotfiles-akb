{
  pkgs,
  config,
  username,
  self,
  ...
}:

{
  system.primaryUser = username;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    android-tools
    bun
    btop
    colima
    docker
    docker-compose
    fd
    fastfetch
    fnm
    ffmpeg
    gcc
    gnupg
    rustlings
    go
    git
    rustc
    cargo
    sqlx-cli
    javaPackages.compiler.openjdk17
    lua
    libiconv
    mkalias
    nixfmt
    openssl_3
    pnpm
    pkg-config
    python3
    ripgrep
    rbenv
    uv
  ];

  environment.variables = {
    LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.libiconv
      pkgs.openssl_3
    ];
    CPATH = pkgs.lib.makeSearchPath "include" [
      pkgs.libiconv
      pkgs.openssl_3
    ];
    PKG_CONFIG_PATH =
      pkgs.lib.makeSearchPath "lib/pkgconfig" [ pkgs.openssl_3 ]
      + ":"
      + pkgs.lib.makeSearchPath "share/pkgconfig" [ pkgs.openssl_3 ];
  };
  
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
      "ghostty"
    ];
  };

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
      };
    in
    pkgs.lib.mkForce ''
      rm -rf /Applications/Nix\ Apps/
      mkdir -p /Applications/Nix\ Apps/
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix\ Apps/$app_name"
      done
    '';

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
