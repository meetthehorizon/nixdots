{
  pkgs,
  config,
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
                  (builtins.getFlake "${config.settings.nixdotsPath}").nixosConfigurations.${hostName}.options
                '';
                home_manager.expr = ''
                  (builtins.getFlake "${config.settings.nixdotsPath}").homeConfigurations."${config.home.username}@${hostName}".options
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
    ];
  };
}
