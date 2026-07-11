{config, ...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;

    settings = {
      format =
        if config.programs.git.enable
        then "$username$git_branch$git_state$git_status$nix_shell$python$line_break$directory$character"
        else "$username$nix_shell$python$line_break$directory$character";

      right_format = "$cmd_duration";

      username = {
        show_always = true;
        style_user = "bold ${config.color.terminal.blue}";
        style_root = "bold ${config.color.terminal.red}";
        format = "[ $user]($style) ";
      };

      directory = {
        style = "bold ${config.color.terminal.blue}";
        format = "[󰉋 $path]($style)[$read_only]($read_only_style) ";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[❯](bold ${config.color.terminal.magenta})";
        error_symbol = "[❯](bold ${config.color.terminal.red})";
        vimcmd_symbol = "[❮](bold ${config.color.terminal.green})";
      };

      git_branch = {
        disabled = !config.programs.git.enable;
        format = "[ $branch]($style) ";
        style = "bold ${config.color.terminal.gray}";
      };

      git_status = {
        disabled = !config.programs.git.enable;
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold ${config.color.terminal.red}";

        conflicted = "󰞇 ";
        ahead = "󰁝 ";
        behind = "󰁅 ";
        diverged = "󰹺 ";
        untracked = "󰋗 ";
        stashed = "󰏗 ";
        modified = "󰷈 ";
        staged = "󰄬 ";
        renamed = "󰑕 ";
        deleted = "󰍵 ";
      };

      git_state = {
        disabled = !config.programs.git.enable;
        format = ''\([$state( $progress_current/$progress_total)]($style)\)'';
        style = "bold ${config.color.terminal.gray}";
      };

      cmd_duration = {
        format = "[ $duration]($style)";
        style = "bold ${config.color.terminal.yellow}";
      };

      python = {
        format = "via [ $virtualenv]($style) ";
        style = "bold ${config.color.terminal.green}";
        detect_extensions = [];
        detect_files = [];
      };

      nix_shell = {
        format = ''via [ $state( \($name\))]($style)'';
        style = "bold ${config.color.terminal.cyan}";
      };
    };
  };
}
