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

    interactiveShellInit = with config.color.terminal; ''
      # Disable greeting
      set -g fish_greeting

      # Theme colors
      set -g fish_color_normal "${config.color.text}"
      set -g fish_color_command "${blue}"
      set -g fish_color_keyword "${magenta}"
      set -g fish_color_quote "${yellow}"
      set -g fish_color_redirection "${cyan}"
      set -g fish_color_end "${magenta}"
      set -g fish_color_error "${red}"
      set -g fish_color_param "${config.color.text}"
      set -g fish_color_comment "${gray}"
      set -g fish_color_selection --background="${config.color.accent}"
      set -g fish_color_search_match --background="${config.color.accent}"

      # Add local bin to path
      fish_add_path $HOME/.local/bin

      # Enable vi key bindings
      fish_vi_key_bindings

      fastfetch

      set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/docker.sock"

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
