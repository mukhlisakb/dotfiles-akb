# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Rust Support

This configuration includes advanced Rust support via `rustaceanvim` and `crates.nvim`.

### Features

- **Autocomplete**:
  - **Packages/Modules**: Intelligent completion for imports and `Cargo.toml` dependencies (e.g., typing "dotenv").
  - **Structs/Methods**: Full semantic completion when typing `.` or method names.
  - **Auto-import**: Selecting an item from the completion menu automatically adds the `use` statement at the top of the file.

- **Integration**:
  - Uses existing `rust-analyzer` installation.
  - Optimized for performance in large projects.

### Usage Examples

1. **Auto-Importing a Module**:
   - In a Rust file, type `HashMap`.
   - Select `HashMap` from the completion dropdown.
   - Result: `use std::collections::HashMap;` is added, and `HashMap` is inserted.

2. **Adding Dependencies**:
   - Open `Cargo.toml`.
   - Under `[dependencies]`, type `dotenv = "`.
   - Completion will suggest available versions.

3. **Method Completion**:
   - Define a struct `struct User { name: String }`.
   - Type `let u = User { name: "John".to_string() };`.
   - Type `u.`.
   - Completion will suggest `name` and other methods.

### Setup for `/Users/vandalicious/nix/modules`

To ensure imports work correctly corresponding to the directory structure:
1. Ensure a `Cargo.toml` exists at the root of your Rust workspace.
2. If working with multiple modules, use a Cargo Workspace.
