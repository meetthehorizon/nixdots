{config, ...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons --group-directories-first";
      v = "nvim";
      g = "git";
      clr = "clear && fastfetch";

      nean = "sudo nix-collect-garbage -d";
      nate = "sudo nixos-rebuild switch --flake ~/nixdots/#horizon";
      nest = "sudo nixos-rebuild test --flake ~/nixdots/#horizon";
    };

    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Theme colors
      set -g fish_color_normal "${config.theme.colors.foreground}"
      set -g fish_color_command "${config.theme.colors.blue}"
      set -g fish_color_keyword "${config.theme.colors.magenta}"
      set -g fish_color_quote "${config.theme.colors.yellow}"
      set -g fish_color_redirection "${config.theme.colors.cyan}"
      set -g fish_color_end "${config.theme.colors.magenta}"
      set -g fish_color_error "${config.theme.colors.red}"
      set -g fish_color_param "${config.theme.colors.foreground}"
      set -g fish_color_comment "${config.theme.colors.gray}"
      set -g fish_color_selection --background="${config.theme.colors.accent}"
      set -g fish_color_search_match --background="${config.theme.colors.accent}"

      # Add local bin to path
      fish_add_path $HOME/.local/bin

      # Enable vi key bindings
      fish_vi_key_bindings

      fastfetch
      if test -f /home/conart/.config/gh/github-pat
        set -gx GITHUB_TOKEN (cat /home/conart/.config/gh/github-pat)
        set -gx GH_TOKEN $GITHUB_TOKEN
      end
    '';
  };
}
