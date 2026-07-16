{
  pkgs,
  config,
  lib,
  hostName,
  ...
}: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          gopls.enable = true;
          lua_ls.enable = true;
          ts_ls.enable = true;
          eslint.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          taplo.enable = true;
          bashls.enable = true;
          qmlls = {
            enable = true;
            cmd = ["qmlls" "-E"];
            filetypes = ["qml" "qmljs"];
            rootMarkers = [
              ".qmlls.ini"
            ];
          };
          nixd = {
            enable = true;
            settings = {
              formatting.command = ["alejandra"];
              options = {
                nixos.expr = ''
                  (builtins.getFlake "${config.nixdotsPath}").nixosConfigurations.${hostName}.options
                '';
                home_manager.expr = ''
                  (builtins.getFlake "${config.nixdotsPath}").homeConfigurations."${config.home.username}@${hostName}".options
                '';
              };
            };
          };
          basedpyright = {
            enable = true;
            settings.basedpyright = {
              disableOrganizeImports = true;
              analysis = {
                typeCheckingMode = "standard";
                useLibraryCodeForTypes = true;
                diagnosticMode = "openFilesOnly";
              };
            };
          };
          ruff = {
            enable = true;
            onAttach.function = ''
              client.server_capabilities.hoverProvider = false
            '';
          };
          svelte = {
            enable = true;
            initOptions.svelte.plugin.typescript.enable = true;
          };
          cssls.enable = true;
        };
        keymaps = {
          extra =
            lib.optionals config.programs.nixvim.plugins.gitsigns.enable
            [
              {
                mode = "n";
                key = "<leader>sdb";
                action = "<cmd>Telescope diagnostics bufnr=0<CR>";
                options.desc = "[S]earch [D]iagnostics [B]uffer";
              }
              {
                mode = "n";
                key = "<leader>sdw";
                action = "<cmd>Telescope diagnostics<CR>";
                options.desc = "[S]earch [D]iagnostics [W]orkspace";
              }
              {
                mode = "n";
                key = "gd";
                action = "<cmd>Telescope lsp_definitions<CR>";
                options.desc = "Go to Definition";
              }
              {
                mode = "n";
                key = "gt";
                action = "<cmd>Telescope lsp_type_definitions<CR>";
                options.desc = "Go to Type Definition";
              }
              {
                mode = "n";
                key = "grr";
                action = "<cmd>Telescope lsp_references<CR>";
                options.desc = "Go to References";
              }
              {
                mode = "n";
                key = "gi";
                action = "<cmd>Telescope lsp_implementations<CR>";
                options.desc = "Go to Implementation";
              }
              {
                mode = "n";
                key = "<leader>sS";
                action = "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>";
                options.desc = "[S]earch Workspace [S]ymbols";
              }
              {
                mode = "n";
                key = "<leader>ss";
                action = "<cmd>Telescope lsp_document_symbols<CR>";
                options.desc = "[S]earch [S]ymbols";
              }
            ];
        };
      };
    };
    extraPackages = with pkgs; [
      alejandra
      basedpyright
      bash-language-server
      clang-tools
      gotools
      kdePackages.qtdeclarative
      prettier
      ruff
      stylua
      taplo
      vscode-langservers-extracted
      svelte-language-server
    ];
  };
}
