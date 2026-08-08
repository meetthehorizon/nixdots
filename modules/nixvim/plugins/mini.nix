{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;

      modules = {
        icons = {
          enable = true;
          directory = {
            ".git".glyph = "󰊢";
            ".github".glyph = "󰊤";
            ".secrets".glyph = "";
            "api".glyph = "󰒋";
            "app".glyph = "";
            "apps".glyph = "";
            "assets".glyph = "󰉔";
            "bin".glyph = "";
            "cli".glyph = "";
            "cmd".glyph = "";
            "component".glyph = "󰐱";
            "components".glyph = "󰐱";
            "db".glyph = "󰆼";
            "doc".glyph = "󰈙";
            "docs".glyph = "󱔗";
            "env".glyph = "";
            "hardware".glyph = "";
            "hyprland".glyph = "";
            "internal".glyph = "";
            "migrations".glyph = "󰳿";
            "nixvim".glyph = "";
            "node_modules".glyph = "󰎙";
            "pkg".glyph = "󰏖";
            "public".glyph = "";
            "routes".glyph = "";
            "scripts".glyph = "󰯂";
            "secrets".glyph = "";
            "service".glyph = "";
            "services".glyph = "";
            "src".glyph = "";
            "test".glyph = "󰙨";
            "tests".glyph = "󰙨";
            "themes".glyph = "󰔎";
            "tmp".glyph = "󰩺";
            "users".glyph = "";
          };
          extension = {
            bash.glyph = "";
            c.glyph = "";
            cpp.glyph = "";
            csv.glyph = "";
            go.glyph = "󰟓";
            h.glyph = "";
            hpp.glyph = "";
            js.glyph = "";
            json.glyph = "";
            jsx.glyph = "";
            lua.glyph = "";
            md.glyph = "";
            nix.glyph = "󱄅";
            py.glyph = "";
            qml.glyph = "";
            sh.glyph = "";
            svelte.glyph = "";
            toml.glyph = "";
            ts.glyph = "";
            tsx.glyph = "";
            yaml.glyph = "";
            yml.glyph = "";
          };
          file = {
            ".gitignore".glyph = "󰊢";
            "Dockerfile".glyph = "";
            "LICENSE".glyph = "";
            "Makefile".glyph = "";
            "README.md".glyph = "󰈙";
            "docker-compose.yml".glyph = "";
            "flake.lock".glyph = "";
            "flake.nix".glyph = "";
            "package-lock.json".glyph = "";
            "package.json".glyph = "";
          };
        };
        ai = {
          n_lines = 50;
          search_method = "cover_or_next";
        };
        surround = {
          mappings = {
            add = "sa";
            delete = "sd";
            find = "sf";
            find_left = "sF";
            highlight = "sh";
            replace = "sr";
            update_n_lines = "sn";
          };
        };
        indentscope = {
          symbol = "│";
          options = {
            try_as_border = true;
            border = "both";
          };
          draw = {
            delay = 50;
            animation = {
              __raw = "require('mini.indentscope').gen_animation.linear({ duration = 5, unit = 'step' })";
            };
          };
        };
      };
    };
  };
}
