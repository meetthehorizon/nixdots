{config, ...}: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;

    theme = {
      manager = {
        cwd = {fg = config.theme.colors.accent;};

        hovered = {
          fg = config.theme.colors.background;
          bg = config.theme.colors.accent;
          bold = true;
        };

        marker_selected = {fg = config.theme.colors.green;};
        marker_copied = {fg = config.theme.colors.yellow;};
        marker_cut = {fg = config.theme.colors.red;};

        border_symbol = "│";
        border_style = {fg = config.theme.colors.gray;};
      };

      status = {
        mode_normal = {
          fg = config.theme.colors.background;
          bg = config.theme.colors.blue;
          bold = true;
        };
        mode_select = {
          fg = config.theme.colors.background;
          bg = config.theme.colors.green;
          bold = true;
        };
        mode_unset = {
          fg = config.theme.colors.background;
          bg = config.theme.colors.magenta;
          bold = true;
        };

        progress_label = {
          fg = config.theme.colors.foreground;
          bold = true;
        };
        permissions_t = {fg = config.theme.colors.blue;};
        permissions_r = {fg = config.theme.colors.yellow;};
        permissions_w = {fg = config.theme.colors.red;};
        permissions_x = {fg = config.theme.colors.green;};
      };

      filetype = {
        rules = [
          {
            mime = "inode/directory";
            fg = config.theme.colors.blue;
          }
          {
            mime = "image/*";
            fg = config.theme.colors.magenta;
          }
          {
            mime = "video/*";
            fg = config.theme.colors.yellow;
          }
          {
            mime = "application/zip";
            fg = config.theme.colors.red;
          }
        ];
      };
    };
  };
}
