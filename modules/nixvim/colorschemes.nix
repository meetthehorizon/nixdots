{config, ...}: {
  programs.nixvim = {
    colorschemes = {
      tokyonight = {
        enable = config.color.style == "tokyonight";
        settings = {
          style = "night";
          styles = {
            sidebars = "transparent";
            floats = "transparent";
          };
          transparent = config.ui.effects.surfaceAlpha != 1;
        };
      };
      catppuccin = {
        enable = config.color.style == "catppuccin";
        settings = {
          flavour = "mocha";
          transparent_background = config.ui.effects.surfaceAlpha != 1;
        };
      };
      gruvbox = {
        enable = config.color.style == "gruvbox";
        settings = {
          transparent_mode = config.ui.effects.surfaceAlpha != 1;
        };
      };
    };

    highlight = {
      NotifyBackground = {
        bg = "#000000";
      };
    };

    extraConfigLua = ''
      ${
        if config.ui.effects.surfaceAlpha != 1
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
