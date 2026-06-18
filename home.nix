{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  makeBinds = bindList:
    map (b: {
      _args =
        [
          (lib.generators.mkLuaInline (builtins.elemAt b 0))
          (lib.generators.mkLuaInline (builtins.elemAt b 1))
        ]
        ++ (
          if builtins.length b > 2
          then [(builtins.elemAt b 2)]
          else []
        );
    })
    bindList;
in {
  # Replace with your exact username and home directory path
  home.username = "conart";
  home.homeDirectory = "/home/conart";

  # Do not change this value unless you thoroughly read the release notes.
  home.stateVersion = "26.05";

  # User-specific packages you want installed
  home.packages = with pkgs; [
    firefox
    hyprlauncher
    wl-clipboard
    fastfetch
    nerd-fonts.jetbrains-mono
    ibm-plex
    brightnessctl
  ];

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./nixvim.nix
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["IBM Plex Sans"];
      serif = ["IBM Plex Serif"];
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "IBM Plex Sans";
      size = 11;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Kshitij Sharma";
        email = "kshitij.dev@proton.me";
      };
      alias = {
        st = "status";
        lg = "log -n 10 --oneline";
        ci = "commit";
        co = "checkout";
        br = "branch";
        fk = "commit --amend --no-edit";
        rb = "rebase";
        rbc = "rebase --continue";
        sq = "rebase -i --autosquash --root";
      };

      core.editor = "nvim";
      init.defaultBranch = "master";
      pull.rebase = true;
      "url \"git@github.com:\"".insteadOf = "https://github.com/";
    };
  };

  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      background_opacity = "0.8";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # These are the modern Zsh features that make it great
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    history = {
      size = 10000;
      save = 10000;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -la";
      v = "nvim";
      g = "git";
      clr = "clear && fastfetch";

      nean = "sudo nix-collect-garbage -d";
      nate = "sudo nixos-rebuild switch --flake ~/.dotfiles/#horizon";
      nest = "sudo nixos-rebuild test --flake ~/.dotfiles/#horizon";
    };

    initContent = ''
      fastfetch
    '';
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "file";
        source = ./underdog.txt;
        color = {
          "1" = "white";
        };
      };

      modules = [
        {
          type = "title";
          color = {
            user = "cyan";
            at = "white";
            host = "white";
          };
          keyIcon = "󰣇"; # The NixOS snowflake icon!
          format = "{user-name-colored}@{host-name-colored}";
        }
        {
          type = "separator";
          color = {
            default = "white";
          };
        }
        {
          type = "os";
          format = "{pretty-name}";
        }
        "wm"
        "kernel"
        "uptime"
        "shell"
        {
          type = "terminal";
          # This color block string is perfectly preserved
          format = "{pretty-name} {#37}█{#97}█ {#36}█{#96}█ {#35}█{#95}█ {#34}█{#94}█ {#33}█{#93}█ {#32}█{#92}█ {#31}█{#91}█ {#30}█{#90}█";
        }
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";

      directory = {
        style = "blue";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        # These preserve the zero-width spaces from your original config
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        # Backslashes must be escaped in Nix strings
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
        # Empty arrays map perfectly to Nix lists
        detect_extensions = [];
        detect_files = [];
      };
    };
  };

  programs.hyprshot.enable = true;
  services.hyprsunset = {
    enable = true;
    settings = {
      profile = [
        {
          time = "00:00";
          temperature = "3000";
          gamma = 0.9;
        }
      ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      mod._var = "SUPER";
      terminal._var = "kitty";
      launcher._var = "hyprlauncher";

      config = {
        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          allow_tearing = false;
          layout = "dwindle";
          "col.active_border" = "rgba(94e2d5aa)";
          "col.inactive_border" = "rgba(2a2a3aaa)";
        };
        decoration = {
          rounding = 4;
          rounding_power = 1;
          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            new_optimizations = true;
            noise = 0.02;
            contrast = 1.0;
            brightness = 0.7;
            xray = true;
          };
        };
        input = {
          kb_layout = "us";
          kb_options = "caps:escape";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
        };
      };

      monitor = {
        output = "eDP-2";
        mode = "2800x1800@120";
        position = "0x0";
        scale = "1.25";
      };
      bind = makeBinds [
        [
          "mod .. \" + SPACE\""
          "hl.dsp.exec_cmd(launcher)"
          {description = "Open application launcher";}
        ]
        [
          "mod .. \" + Q\""
          "hl.dsp.exec_cmd(terminal)"
          {description = "Open terminal";}
        ]
        [
          "mod .. \" + C\""
          "hl.dsp.window.close()"
          {description = "Close focused window";}
        ]
        [
          "mod .. \" + M\""
          "hl.dsp.exit()"
          {
            description = "Exit Hyprland completely";
            locked = true;
          }
        ]
        [
          "\"XF86AudioRaiseVolume\""
          "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+\")"
          {
            description = "Raise Volume";
            locked = "true";
            repeating = "true";
          }
        ]
        [
          "\"XF86AudioLowerVolume\""
          "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")"
          {
            description = "Lower Volume";
            locked = "true";
            repeating = "true";
          }
        ]
        [
          "\"XF86AudioMute\""
          "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ toggle\")"
          {
            description = "Toggle Mute State";
            locked = "true";
          }
        ]
        [
          "\"XF86AudioMicMute\""
          "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SOURCE@ toggle\")"
          {
            description = "Toggle Mic Mute State";
            locked = "true";
          }
        ]
        [
          "\"XF86MonBrightnessUp\""
          "hl.dsp.exec_cmd(\"brightnessctl -e4 -n40000 set 5%+ -d \\\"amdgpu_bl*\\\"\")"
          {
            description = "Raise Brightness";
            locked = "true";
            repeating = "true";
          }
        ]
        [
          "\"XF86MonBrightnessDown\""
          "hl.dsp.exec_cmd(\"brightnessctl -e4 -n40000 set 5%- -d \\\"amdgpu_bl*\\\"\")"
          {
            description = "Lower Brightness";
            locked = "true";
            repeating = "true";
          }
        ]
        [
          "\"XF86AudioNext\""
          "hl.dsp.exec_cmd(\"playerctl next\")"
          {
            description = "Play Next Media";
            locked = "true";
          }
        ]
        [
          "\"XF86AudioPrev\""
          "hl.dsp.exec_cmd(\"playerctl previous\")"
          {
            description = "Play Previous Media";
            locked = "true";
          }
        ]
        [
          "\"XF86AudioPause\""
          "hl.dsp.exec_cmd(\"playerctl play-pause\")"
          {
            description = "Pause Media";
            locked = "true";
          }
        ]
        [
          "\"XF86AudioPlay\""
          "hl.dsp.exec_cmd(\"playerctl play-pause\")"
          {
            description = "Play Media";
            locked = "true";
          }
        ]
        [
          "\"XF86Launch1\""
          "hl.dsp.exec_cmd(\"rog-control-center\")"
          {
            description = "Launch ROG Control Center";
          }
        ]
        [
          "\"SUPER + SHIFT + S\""
          "hl.dsp.exec_cmd(\"pidof slurp || hyprshot -m window -o ~/Pictures/Screenshots/\")"
          {
            description = "Take Screenshot of Window";
          }
        ]
        [
          "mod .. \" + S\""
          "hl.dsp.exec_cmd(\"pidof slurp || hyprshot -m region -o ~/Pictures/Screenshots/\")"
          {
            description = "Take Screenshot of Region";
          }
        ]
        [
          "mod .. \" + N\""
          "hl.dsp.exec_cmd(\"systemctl --user is-active --quiet hyprsunset && systemctl --user stop hyprsunset || systemctl --user start hyprsunset\")"
          {
            description = "Toggle Night Light";
          }
        ]
        [
          "mod .. \" + F\""
          "hl.dsp.window.fullscreen()"
          {
            description = "Toggle Fullscreen of Active Window";
          }
        ]
      ];
    };
    extraConfig = "";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
