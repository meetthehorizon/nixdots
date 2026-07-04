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
        };
      };
    };
    extraPackages = with pkgs; [
      alejandra
      clang-tools
      gotools
      stylua
      prettier
      taplo
    ];
  };
}
