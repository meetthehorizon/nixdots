{
  config,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = lib.mkMerge [
      (lib.mkIf config.programs.eza.enable {
        ls = "eza --icons";
        ll = "eza -la --icons --group-directories-first";
      })
      (lib.mkIf config.programs.fastfetch.enable {
        clr = "clear && fastfetch";
      })
    ];

    shellAbbrs = lib.mkMerge [
      (lib.mkIf config.programs.nixvim.enable {
        v = "nvim";
      })
      (lib.mkIf config.programs.git.enable {
        g = "git";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gs = "git status";
        gb = "git branch";
        gpl = "git pull";
        gfk = "git commit --amend --no-edit";
        gco = "git checkout";
        glo = "git log --oneline";
        grs = "git restore --staged";
        grh = "git reset --hard";
        grb = "git rebase";
        grbs = "git rebase -i --autosquash --root";
        grbc = "git rebase --continue";
      })
      {
        nrs = "sudo nixos-rebuild switch --flake .";
        nrt = "sudo nixos-rebuild test --flake .";
        nd = "nix develop";
        hms = "home-manager switch --flake .";
      }
    ];

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
      ${lib.optionalString (config.secret.githubPat.enable or false) (let
        fishPath = builtins.replaceStrings ["\${XDG_RUNTIME_DIR}"] ["$XDG_RUNTIME_DIR"] config.age.secrets.github-pat.path;
      in ''
        if test -f "${fishPath}"
          set -gx GITHUB_TOKEN (cat "${fishPath}")
          set -gx GH_TOKEN $GITHUB_TOKEN
        end
      '')}
    '';
  };
}
