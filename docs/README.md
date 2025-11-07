# Neovim Configuration Documentation

This document provides an overview of the new Neovim configuration structure, explains the rationale behind the changes, and offers guidance on how to add new plugins.

## New File Structure

The Neovim configuration has been restructured to improve modularity and maintainability. The new structure is as follows:

- `init.lua`: The main entry point of the configuration. It loads the core user settings and the plugin configurations.
- `lua/user/`: This directory contains the core user configurations, such as options, keymaps, and autocommands.
- `lua/plugins/`: This directory contains all the plugin configurations. Each plugin has its own file, which makes it easy to manage them individually.
- `lua/utils/`: This directory contains utility functions that are used by the plugin configurations.
- `docs/`: This directory contains the documentation for the configuration.

## Rationale Behind the Changes

The previous configuration had all the plugin configurations in a single file, which made it difficult to manage. The new structure separates each plugin into its own file, which makes it much easier to add, remove, or update plugins.

The new structure also makes it easier to understand the configuration, as each file has a clear purpose.

## How to Add a New Plugin

To add a new plugin, simply create a new `.lua` file in the `lua/plugins/` directory. The file should return a table that contains the plugin's specification, as defined by `lazy.nvim`.

For example, to add the `gitsigns.nvim` plugin, you would create a file named `lua/plugins/gitsigns.lua` with the following content:

```lua
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
  end,
}
```
