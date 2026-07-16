# AGENTS.md — modules/nixvim

> Declarative Neovim configuration via [nixvim](https://nix-community.github.io/nixvim/).
> Every plugin is a thin Nix wrapper around upstream plugin options.
> The root `default.nix` imports `plugins/` (the directory module) plus
> `colorschemes.nix`, `keymaps.nix`, and `options.nix`.
>
> **References:** [nixvim Documentation](https://nix-community.github.io/nixvim/),
> [nixvim User Guide](https://nix-community.github.io/nixvim/user-guide/),
> [nixvim Plugins](https://nix-community.github.io/nixvim/plugins/)

## 1. File Map

```
modules/nixvim/
├── default.nix           # Top-level: enables nixvim, imports sub-modules
├── options.nix           # Editor opts (tabstop, shiftwidth, clipboard, etc.)
├── keymaps.nix           # Keymaps with conditional plugin gating
├── colorschemes.nix      # Colorscheme from config.color.style, transparency
├── snippets/             # Lua snippet files (e.g., go.lua)
└── plugins/
    ├── default.nix       # Imports all plugin files
    ├── blink.nix         # blink-cmp (completion)
    ├── conform.nix       # conform-nvim (formatting)
    ├── dap.nix           # DAP (debugging)
    ├── dressing.nix      # dressing.nvim (UI)
    ├── gitsigns.nix      # gitsigns.nvim (git)
    ├── lazygit.nix       # lazygit.nvim
    ├── lint.nix          # nvim-lint
    ├── lsp.nix           # LSP servers + keymaps
    ├── lualine.nix       # lualine (statusline)
    ├── luasnip.nix       # LuaSnip (snippets)
    ├── mini.nix          # mini.nvim collection
    ├── notify.nix        # nvim-notify
    ├── nvim-autopairs.nix
    ├── oil.nix           # oil.nvim (file explorer)
    ├── snacks.nix        # snacks.nvim
    ├── telescope.nix     # telescope.nvim
    ├── treesitter.nix    # treesitter + grammars
    ├── venv-selector.nix # Python venv selector
    └── which-key.nix     # which-key.nvim
```

## 2. Mechanical Invariants

1. **One plugin per file.** Each `modules/nixvim/plugins/*.nix` configures
   exactly one plugin. Import it in `plugins/default.nix`.
2. **Thin wrappers only.** Plugin files expose upstream plugin options
   through nixvim's `programs.nixvim.plugins.<name>` namespace. Custom Lua
   goes in `extraConfigLua` blocks, not standalone files.
3. **Conditional keymaps reference plugin state.** Keymaps in `keymaps.nix`
   use `lib.optionals plugins.<name>.enable` to only bind keys when the
   plugin is active. This prevents errors from keymaps referencing
   unloaded plugins.
4. **Extra packages go in the module that needs them.** `extraPackages`
   (LSP servers, formatters, linters) are declared in the same file that
   configures the tool — `lsp.nix` for language servers, `conform.nix`
   for formatters, `lint.nix` for linters.
5. **Design tokens via `config.*`.** Colorscheme selection is driven by
   `config.color.style` (tokyonight, catppuccin, gruvbox). Transparency
   is driven by `config.ui.effects.surfaceAlpha`. Never hardcode theme
   names or opacity values.
6. **nixd LSP is project-aware.** The nixd server in `lsp.nix` is
   configured with `nixos.expr` and `home_manager.expr` referencing
   the flake — this gives nixvim full autocompletion for NixOS and
   home-manager options.

## 3. Plugin Pattern (Template)

```nix
# modules/nixvim/plugins/myplugin.nix
{ pkgs, ... }: {
  programs.nixvim = {
    plugins.myplugin = {
      enable = true;
      settings = {
        # upstream plugin options
      };
    };
    # If the plugin needs external binaries:
    extraPackages = with pkgs; [ myplugin-binary ];
  };
}
```

Import in `plugins/default.nix`:
```nix
{ imports = [
    # ... existing ...
    ./myplugin.nix
  ];
}
```

## 4. Keymap Conventions

- **Leader:** `<space>` (set in `options.nix`)
- **Naming:** `<leader><category><action>` — e.g., `<leader>sf` = [S]earch [F]iles.
  The mnemonic letter is capitalized in the `desc` string.
- **Diagnostic jumps:** `[d` / `]d` (all diagnostics), `[D` / `]D` (errors only).
- **LSP:** `gD` (declaration), `K` (hover), `<C-k>` (signature), `<leader>rn` (rename),
  `<leader>ca` (code action).
- **Git:** `<leader>gX` prefix — `gp` (preview), `gs` (stage), `gr` (reset), `gu` (unstage).
- **Telescope:** `<leader>sX` prefix — `sf` (files), `sg` (grep), `sb` (buffers),
  `sh` (help), `sk` (keymaps), `sc` (config — scoped to `~/nixdots`).
- **Debug:** `F5` (continue), `F9` (breakpoint), `F10` (step over), `F11` (step into),
  `F12` (step out). DAP UI: `<leader>du` (toggle), `<leader>de` (evaluate).

## 5. LSP & Formatting

- **LSP servers** (`lsp.nix`): Each server declared under
  `plugins.lsp.servers.<name>`. nixd uses `alejandra` as the formatter.
  basedpyright disables organize imports (ruff handles that). ruff disables
  hover (basedpyright owns hover).
- **Formatting** (`conform.nix`): `format_on_save` with `lsp_format = "fallback"`.
  Formatters mapped by filetype — alejandra (nix), goimports+gofmt (go),
  clang-format (cpp), stylua (lua), prettier (js/ts/json/yaml), taplo (toml),
  ruff (python), shfmt (sh/bash).
- **Linting** (`lint.nix`): Separate from formatting. Configure linters per
  filetype.
- **Treesitter** (`treesitter.nix`): `indent.enable = true`. Grammars
  installed via `grammarPackages` from `builtGrammars`.

## 6. Completion (blink-cmp)

Sources are conditionally assembled from enabled plugins: `lsp` and `snippets`
are included only when their respective plugins are enabled. `path` and `buffer`
are always active. Border style is `rounded` for menu, documentation, and
signature windows.

## 7. Colorscheme & Transparency

The active colorscheme is selected by matching `config.color.style`:
`"tokyonight"` → tokyonight, `"catppuccin"` → catppuccin mocha,
`"gruvbox"` → gruvbox. When `config.ui.effects.surfaceAlpha != 1`, an
`extraConfigLua` autocmd forces `bg = "none"` on key UI highlight groups
(Normal, FloatBorder, NeoTreeNormal, SignColumn, etc.) on every
`ColorScheme` event.

## 8. Common Pitfalls

- **Don't add keymaps directly in plugin files.** They go in `keymaps.nix`
  with the `lib.optionals` guard pattern.
- **Don't reference plugins that might be disabled.** Always use
  `lib.optionals plugins.<name>.enable` or `lib.optional`.
- **`extraPackages` vs `plugins.<name>.package`:** `extraPackages` adds to
  the Neovim PATH. `plugins.<name>.package` overrides the plugin's binary.
  Know which one you need.
- **nixd options:** The flake expressions for `nixos.expr` and
  `home_manager.expr` must evaluate at build time. If the flake path
  changes, update `config.nixdotsPath`.
