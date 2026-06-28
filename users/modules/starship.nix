{...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = "$username$git_branch$git_state$git_status$nix_shell$python$line_break$directory$character";
      right_format = "$cmd_duration";

      username = {
        show_always = true;
        style_user = "bold #89b4fa";
        style_root = "bold #f38ba8";
        format = "[ $user]($style) ";
      };

      directory = {
        style = "bold #b4befe";
        format = "[󰉋 $path]($style)[$read_only]($read_only_style) ";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[❯](bold #cba6f7)";
        error_symbol = "[❯](bold #f38ba8)";
        vimcmd_symbol = "[❮](bold #a6e3a1)";
      };

      git_branch = {
        format = "[ $branch]($style) ";
        style = "bold #9399b2";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold #eba0ac";
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
        style = "bold #9399b2";
      };

      cmd_duration = {
        format = "[󱎦 $duration]($style)";
        style = "bold #f9e2af";
      };

      python = {
        format = "via [ $virtualenv]($style) ";
        style = "bold #a6e3a1";
        # Empty arrays map perfectly to Nix lists
        detect_extensions = [];
        detect_files = [];
      };

      nix_shell = {
        format = "via [ $state( \\($name\\))]($style) ";
        style = "bold #74c7ec";
      };
    };
  };
}
