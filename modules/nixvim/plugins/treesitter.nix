{config, ...}: {
  programs.nixvim.plugins.treesitter = {
    enable = true;

    indent.enable = true;

    grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
      bash
      c
      cpp
      css
      go
      html
      javascript
      json
      lua
      markdown
      nix
      python
      qmljs
      rust
      svelte
      toml
      typescript
      yaml
    ];
  };
}
