{...}: {
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
