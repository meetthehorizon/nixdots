{config, ...}: {
  programs.nixvim = {
    colorschemes = {
      tokyonight = {
        enable = config.theme.neovim.colorscheme == "tokyonight";
        settings = {
          style = "night";
          transparent = config.theme.neovim.transparent;
          styles = {
            sidebars = if config.theme.neovim.transparent then "transparent" else "dark";
            floats = if config.theme.neovim.transparent then "transparent" else "dark";
          };
        };
      };
      catppuccin = {
        enable = config.theme.neovim.colorscheme == "catppuccin";
        settings = {
          flavour = "mocha";
          transparent_background = config.theme.neovim.transparent;
        };
      };
      gruvbox = {
        enable = config.theme.neovim.colorscheme == "gruvbox";
        settings = {
          transparent_mode = config.theme.neovim.transparent;
        };
      };
      dracula = {
        enable = config.theme.neovim.colorscheme == "dracula";
      };
      nord = {
        enable = config.theme.neovim.colorscheme == "nord";
      };
      onedark = {
        enable = config.theme.neovim.colorscheme == "onedark";
      };
    };

    extraConfigLua = ''
      require("luasnip.loaders.from_lua").load({
        paths = {
          "${../../snippets}"
        }
      })

      ${if config.theme.neovim.transparent then ''
        -- Ensure all UI elements and sidebars are fully transparent
        local function apply_transparency()
          local groups = {
            "Normal", "NormalNC", "NormalFloat", "FloatBorder",
            "NeoTreeNormal", "NeoTreeNormalNC", "SignColumn",
            "LineNr", "CursorLineNr", "WinSeparator", "VertSplit"
          }
          for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
          end
        end

        -- Run immediately and on Colorscheme changes
        apply_transparency()
        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = "*",
          callback = apply_transparency,
        })
      '' else ""}
    '';
  };
}
