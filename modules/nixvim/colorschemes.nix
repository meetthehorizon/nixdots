{config, ...}: {
  programs.nixvim = {
    colorschemes = {
      tokyonight = {
        enable = config.theme.colorscheme == "tokyonight";
        settings = {
          style = "night";
          transparent = config.theme.neovim.transparent;
        };
      };
      catppuccin = {
        enable = config.theme.colorscheme == "catppuccin";
        settings = {
          flavour = "mocha";
          transparent_background = config.theme.neovim.transparent;
        };
      };
      gruvbox = {
        enable = config.theme.colorscheme == "gruvbox";
        settings = {
          transparent_mode = config.theme.neovim.transparent;
        };
      };
    };

    extraConfigLua = ''
      ${
        if config.theme.neovim.transparent
        then ''
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
        ''
        else ""
      }
    '';
  };
}
