{...}: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        icons = {
          directory = {
            "bin" = {glyph = "";};
            "cmd" = {glyph = "";};
            "db" = {glyph = "󰆼";};
            "migrations" = {glyph = "󰳿";};
            "env" = {glyph = "";};
            "scripts" = {glyph = "󰯂";};
            "tmp" = {glyph = "󰩺";};
            "src" = {glyph = "";};
            "api" = {glyph = "󰒋";};
            "pkg" = {glyph = "󰏖";};
            "internal" = {glyph = "";};
            "assets" = {glyph = "󰉔";};
            "component" = {glyph = "󰐱";};
            "components" = {glyph = "󰐱";};
            "public" = {glyph = "";};
            "docs" = {glyph = "󱔗";};
            "doc" = {glyph = "󰈙";};
            "test" = {glyph = "󰙨";};
            "tests" = {glyph = "󰙨";};
            ".git" = {glyph = "󰊢";};
            ".github" = {glyph = "󰊤";};
            "node_modules" = {glyph = "󰎙";};
          };
        };
      };
    };
  };
}
