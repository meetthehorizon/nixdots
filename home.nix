{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  makeLuaCode = bindList:
    map (args: {
      _args =
        map (
          arg:
            if builtins.isAttrs arg
            then arg
            else lib.generators.mkLuaInline arg
        )
        args;
    })
    bindList;
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  assets = import ./assets.nix {inherit pkgs;};
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
    awww
    spotify

    gh
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default

    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-no-fhs
    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-cli
  ];

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./nixvim.nix
  ];

  home.file = {
    "Pictures/Icons".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Icons";
    "Pictures/Wallpapers/Private".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Wallpapers";

    ".face".source = assets.userIcon;
    ".config/fastfetch/logo.png".source = assets.nixosIcon;
    "Pictures/Wallpapers/home".source = assets.homeScreen;
    "Pictures/Wallpapers/lock".source = assets.lockScreen;
  };

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

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "github.com" = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/id_ed25519";
        User = "git";
      };
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
      if [ -f /home/conart/.config/gh/github-pat ]; then
        export GITHUB_TOKEN=$(cat /home/conart/.config/gh/github-pat)
        export GH_TOKEN=$GITHUB_TOKEN
      fi
    '';
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${config.home.homeDirectory}/.config/fastfetch/logo.png";
        type = "auto";
        width = 15;
        padding = {
          top = 2;
          left = 2;
          right = 2;
        };
      };

      # --- NEW: Global Display Settings ---
      display = {
        separator = "  "; # Replaces the default ":" with clean whitespace
        color = {
          keys = "cyan"; # Unifies all key colors to match the title
        };
        key = {
          width = 14; # Forces perfect vertical alignment for all values
        };
      };

      modules = [
        "break" # Adds a blank line at the top for breathing room

        {
          type = "title";
          color = {
            user = "cyan";
            at = "white";
            host = "cyan";
          };
        }

        "break"

        {
          type = "os";
          key = "  OS";
          keyColor = "blue";
          format = "{pretty-name}";
        }
        {
          type = "kernel";
          key = " 󰌽 Kernel";
          keyColor = "magenta";
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = "red";
        }
        {
          type = "shell";
          key = "  Shell";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = " 󰔚 Uptime";
          keyColor = "yellow";
        }

        {
          type = "colors";
          key = " 󰸱 Color";
          symbol = "circle";
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
          time = "22:00";
          temperature = "3000";
          gamma = 0.9;
        }
      ];
    };
  };

  systemd.user.services.awww = {
    Unit = {
      Description = "Awww Wallpaper Daemon";
      # Tie it to the lifecycle of your graphical Wayland session
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      # The absolute path to the binary ensures it always executes correctly
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      ExecStop = "${pkgs.awww}/bin/awww kill";
      Restart = "on-failure";
      RestartSec = "2"; # Wait 2 seconds before trying to restart
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          # Assuming you updated your assets.nix to output to this path!
          path = "${config.home.homeDirectory}/Pictures/Wallpapers/lock";
          blur_passes = 3;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      image = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/.face";
          border_size = 0;
          border_color = "rgba(148, 226, 213, 1.0)";
          size = 180;
          rounding = -1;
          rotate = 0.0;
          reload_time = -1;
          reload_cmd = "";
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 60";
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgb(148, 226, 213)";
          inner_color = "rgba(30, 30, 46, 0.9)";
          font_color = "rgb(205, 214, 244)";
          fade_on_empty = false;
          font_family = "IBM Plex Sans";
          placeholder_text = "<span foreground=\"##ffffff80\">you shall not pass!</span>";
          hide_input = false;
          position = "0, -210";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Day-Month-Date
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
          color = "rgb(205, 214, 244)";
          font_size = 25;
          font_family = "IBM Plex Sans";
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        # Time (BOLD + brighter)
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b>$(date +%I:%M)</b>\"";
          color = "rgb(205, 214, 244)";
          font_size = 120;
          font_family = "IBM Plex Sans";
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "  $USER";
          color = "rgb(205, 214, 244)";
          font_size = 18;
          font_family = "IBM Plex Sans";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      shape = [
        # USER-BOX
        {
          monitor = "";
          size = "300, 60";
          color = "rgba(30, 30, 46, 0.9)";
          rounding = -1;
          border_size = 0;
          border_color = "rgb(249, 226, 175)";
          rotate = 0.0;
          xray = false;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        # OUTER BOX 1
        {
          monitor = "";
          size = "500, 700";
          color = "rgba(30, 30, 46, 0.6)";
          rounding = 1;
          border_size = 0;
          border_color = "rgb(148, 226, 213)";
          rotate = 0.0;
          xray = false;
          position = "0, 70";
          halign = "center";
          valign = "center";
        }
        # OUTER BOX 2 (Line)
        {
          monitor = "";
          size = "498, 0";
          color = "rgba(30, 30, 46, 0.6)";
          rounding = 0;
          border_size = 2;
          border_color = "rgb(148, 226, 213)";
          rotate = 0.0;
          xray = false;
          position = "0, -280";
          halign = "center";
          valign = "center";
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
        xwayland = {
          force_zero_scaling = true;
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

      monitor = makeLuaCode [
        [
          {
            output = "eDP-2";
            mode = "2800x1800@120";
            position = "0x0";
            scale = "1.25";
          }
        ]
        [
          {
            output = "eDP-1";
            mode = "2800x1800@120";
            position = "0x0";
            scale = "1.25";
          }
        ]
      ];

      bind = makeLuaCode (
        [
          [
            ''mod .. " + SPACE"''
            ''hl.dsp.exec_cmd(launcher)''
            {
              description = "Open application launcher";
            }
          ]
          [
            ''mod .. " + Q"''
            ''hl.dsp.exec_cmd(terminal)''
            {
              description = "Open terminal";
            }
          ]
          [
            ''mod .. " + C"''
            ''hl.dsp.window.close()''
            {
              description = "Close focused window";
            }
          ]
          [
            ''mod .. " + M"''
            ''hl.dsp.exit()''
            {
              description = "Exit Hyprland completely";
              locked = true;
            }
          ]
          [
            ''"XF86AudioRaiseVolume"''
            ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")''
            {
              description = "Raise Volume";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86AudioLowerVolume"''
            ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")''
            {
              description = "Lower Volume";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86AudioMute"''
            ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ toggle")''
            {
              description = "Toggle Mute State";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioMicMute"''
            ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ toggle")''
            {
              description = "Toggle Mic Mute State";
              locked = "true";
            }
          ]
          [
            ''"XF86MonBrightnessUp"''
            ''hl.dsp.exec_cmd("brightnessctl -e4 -n40000 set 5%+ -d \"amdgpu_bl*\"")''
            {
              description = "Raise Brightness";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86MonBrightnessDown"''
            ''hl.dsp.exec_cmd("brightnessctl -e4 -n40000 set 5%- -d \"amdgpu_bl*\"")''
            {
              description = "Lower Brightness";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86AudioNext"''
            ''hl.dsp.exec_cmd("playerctl next")''
            {
              description = "Play Next Media";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioPrev"''
            ''hl.dsp.exec_cmd("playerctl previous")''
            {
              description = "Play Previous Media";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioPause"''
            ''hl.dsp.exec_cmd("playerctl play-pause")''
            {
              description = "Pause Media";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioPlay"''
            ''hl.dsp.exec_cmd("playerctl play-pause")''
            {
              description = "Play Media";
              locked = "true";
            }
          ]
          [
            ''"XF86Launch1"''
            ''hl.dsp.exec_cmd("rog-control-center")''
            {
              description = "Launch ROG Control Center";
            }
          ]
          [
            ''"SUPER + SHIFT + S"''
            ''hl.dsp.exec_cmd("pidof slurp || hyprshot -m window -o ~/Pictures/Screenshots/")''
            {
              description = "Take Screenshot of Window";
            }
          ]
          [
            ''mod .. " + S"''
            ''hl.dsp.exec_cmd("pidof slurp || hyprshot -m region -o ~/Pictures/Screenshots/")''
            {
              description = "Take Screenshot of Region";
            }
          ]
          [
            ''mod .. " + N"''
            ''hl.dsp.exec_cmd("systemctl --user is-active --quiet hyprsunset && systemctl --user stop hyprsunset || systemctl --user start hyprsunset")''
            {
              description = "Toggle Night Light";
            }
          ]
          [
            ''mod .. " + F"''
            ''hl.dsp.window.fullscreen()''
            {
              description = "Toggle Fullscreen of Active Window";
            }
          ]
          [
            ''mod .. " + V"''
            ''hl.dsp.window.float()''
            {
              description = "Toggle Fullscreen of Active Window";
            }
          ]
          [
            ''mod .. " + h"''
            ''hl.dsp.focus({direction="l"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + l"''
            ''hl.dsp.focus({direction="r"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + k"''
            ''hl.dsp.focus({direction="u"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + j"''
            ''hl.dsp.focus({direction="d"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + mouse:272"''
            ''hl.dsp.window.drag()''
            {
              description = "Move Windows using mouse";
              mouse = true;
            }
          ]
          [
            ''mod .. " + mouse:273"''
            ''hl.dsp.window.resize()''
            {
              description = "Move Windows using mouse";
              mouse = true;
            }
          ]
          [
            ''mod .. " + SHIFT + L"''
            ''hl.dsp.exec_cmd("hyprlock")''
            {
              description = "Lock Screen";
            }
          ]
        ]
        ++ builtins.genList
        (i: [
          ''mod .. " + ${toString (i + 1)}"''
          ''hl.dsp.focus({ workspace = "${toString (i + 1)}" })''
          {
            description = "Focus workspace ${toString (i + 1)}";
          }
        ])
        9
        ++ builtins.genList
        (i: [
          ''mod .. " + SHIFT + ${toString (i + 1)}"''
          ''hl.dsp.window.move({ workspace = "${toString (i + 1)}" })''
          {
            description = "Move window to workspace ${toString (i + 1)}";
          }
        ])
        9
      );
    };
    extraConfig = "";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
