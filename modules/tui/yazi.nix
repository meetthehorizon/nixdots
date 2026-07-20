{config, ...}: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;

    theme = {
      manager = {
        cwd = {fg = config.color.accent;};

        hovered = {
          fg = config.color.surface;
          bg = config.color.accent;
          bold = true;
        };

        marker_selected = {fg = config.color.terminal.green;};
        marker_copied = {fg = config.color.terminal.yellow;};
        marker_cut = {fg = config.color.terminal.red;};

        border_symbol = "│";
        border_style = {fg = config.color.terminal.gray;};
      };

      status = {
        mode_normal = {
          fg = config.color.surface;
          bg = config.color.terminal.blue;
          bold = true;
        };
        mode_select = {
          fg = config.color.surface;
          bg = config.color.terminal.green;
          bold = true;
        };
        mode_unset = {
          fg = config.color.surface;
          bg = config.color.terminal.magenta;
          bold = true;
        };

        progress_label = {
          fg = config.color.surfaceVariant;
          bold = true;
        };
        permissions_t = {fg = config.color.terminal.blue;};
        permissions_r = {fg = config.color.terminal.yellow;};
        permissions_w = {fg = config.color.terminal.red;};
        permissions_x = {fg = config.color.terminal.green;};
      };

      filetype = {
        rules = [
          {
            mime = "inode/directory";
            fg = config.color.terminal.blue;
          }
          {
            mime = "image/*";
            fg = config.color.terminal.magenta;
          }
          {
            mime = "video/*";
            fg = config.color.terminal.yellow;
          }
          {
            mime = "application/zip";
            fg = config.color.terminal.red;
          }
        ];
      };
    };
  };

  xdg.desktopEntries.yazi = {
    name = "File Manager";
    exec = ''sh -c "flock -n /tmp/yazi.lock footclient yazi"'';
    icon = "system-file-manager";
    type = "Application";
    categories = ["System"];
  };
}
