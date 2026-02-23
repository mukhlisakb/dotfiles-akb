{
  pkgs,
  hostname,
  ...
}:
{
  home.packages = with pkgs; [
    cloudflared
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
      ];
    };

    shellAliases = {
      drb = "sudo darwin-rebuild switch --flake ~/nix#${hostname}";
      ngc = "nix-collect-garbage -d";
      lg = "lazygit";
      vim = "nvim";
      ls = "eza --color=always --icons=always --group-directories-first";
      ll = "eza -l --color=always --icons=always --group-directories-first";
      la = "eza -la --color=always --icons=always --group-directories-first";
      cat = "bat";
    };

    initContent = ''
      export EDITOR=nvim

      eval "$(fnm env --use-on-cd --shell zsh)"
    '';
  };

}
