# Neovim Configuration Personal Use

This repository contains my personal dotfiles, tailored for my own development environment. If you'd like to use these dotfiles, there are some specific requirements that need to be met for proper configuration and functionality.

### Prerequisites

Before using these dotfiles, please ensure that you have the following installed:

1. iTerm2 or Warp (Terminal Emulator)
2. Oh My Zsh (Zsh Framework)
3. Powerlevel10k (Zsh Theme)
4. Melson (Custom Configuration FONT)
   Additionally, you will need to install the following essential packages on your OS to support this configuration: `git, fzf, fd, lldb, and ripgrep.` Keep in mind that the package names might differ depending on the Linux distribution you're using, so make sure to install the appropriate packages for your system.

### Neovim configuration

For the language server support, this configuration uses [Neovim LSP.](https://github.com/neovim/nvim-lspconfig) You can find more detailed information about the setup and usage in the linked repository.

### Plugin Management

The configuration utilizes `lazy.nvim` for managing plugins. To ensure everything is working smoothly, you can run the following commands after installation:

`:checkhealth lazy` - Recommended to check the health of the plugins and configurations.
`:Lazy` - To manage plugins (install, update, clean, etc.).

### Key Mappings

The key mappings follow these conventions based on mode:

`n`: Normal mode
`v`: Visual and Select modes
`o`: Operator-pending mode
`x`: Visual mode only
`s`: Select mode only
`i`: Insert mode
`c`: Command-line mode
`l`: Insert, Command-line, RegExp-search ("Lang-Arg" pseudo-mode)
The comma (`,` or Space) key is used as the `leader` key. Pressing the leader key in Neovim will show you the available shortcut keys configured for various functionalities.

### Additional Information

This setup is optimized for a personal workflow, integrating various tools for efficiency and speed. It supports a variety of language servers through Neovim's LSP configuration, allowing for smooth development across different languages. If you're looking to customize or expand the setup, feel free to adjust the configurations to suit your own development needs.

Happy coding!
