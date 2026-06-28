{config, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = "$username$git_branch$git_state$git_status$nix_shell$python$line_break$directory$character";
      right_format = "$cmd_duration";

      username = {
        show_always = true;
        style_user = "bold ${config.theme.colors.blue}";
        style_root = "bold ${config.theme.colors.red}";
        format = "[ $user]($style) ";
      };

      directory = {
        style = "bold ${config.theme.colors.light_blue}";
        format = "[󰉋 $path]($style)[$read_only]($read_only_style) ";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[❯](bold ${config.theme.colors.magenta})";
        error_symbol = "[❯](bold ${config.theme.colors.red})";
        vimcmd_symbol = "[❮](bold ${config.theme.colors.green})";
      };

      git_branch = {
        format = "[ $branch]($style) ";
        style = "bold ${config.theme.colors.gray}";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold ${config.theme.colors.red}";
        conflicted = "󰞇 ";
        ahead = "󰶟 ";
        behind = "󰶞 ";
        diverged = "󰹹 ";
        untracked = "󰛑 ";
        stashed = "󰆓 ";
        modified = "󰚌 ";
        staged = "󰜶 ";
        renamed = "󰪹 ";
        deleted = "󰆴 ";
      };

      git_state = {
        # Backslashes must be escaped in Nix strings
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bold ${config.theme.colors.gray}";
      };

      cmd_duration = {
        format = "[󱎦 $duration]($style)";
        style = "bold ${config.theme.colors.yellow}";
      };

      python = {
        format = "via [ $virtualenv]($style) ";
        style = "bold ${config.theme.colors.green}";
        detect_extensions = [];
        detect_files = [];
      };

      nix_shell = {
        format = "via [ $state( \\($name\\))]($style) ";
        style = "bold ${config.theme.colors.cyan}";
      };
    };
  };
}
