{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      dap.enable = true;

      # Python debugger
      dap-python.enable = true;

      dap-ui.enable = true;

      # Manual adapters for languages without first-party nixvim modules
      dap.adapters = {
        servers = {
          # C/C++ / Rust: lldb-vscode
          codelldb = {
            port = 13000;
            executable = {
              command = "${pkgs.lldb}/bin/lldb-vscode";
              args = ["--port" "13000"];
            };
          };

          # Go: delve
          delve = {
            port = 38697;
            executable = {
              command = "${pkgs.delve}/bin/dlv";
              args = ["dap" "-l" "127.0.0.1:38697"];
            };
          };
        };
      };

      dap.configurations = {
        cpp = [
          {
            name = "Launch (lldb)";
            type = "codelldb";
            request = "launch";
            program = "\${workspaceFolder}/build/\${workspaceFolderBasename}";
            cwd = "\${workspaceFolder}";
            stopOnEntry = false;
          }
        ];
        c = [
          {
            name = "Launch (lldb)";
            type = "codelldb";
            request = "launch";
            program = "\${workspaceFolder}/build/\${workspaceFolderBasename}";
            cwd = "\${workspaceFolder}";
            stopOnEntry = false;
          }
        ];
        rust = [
          {
            name = "Launch (lldb)";
            type = "codelldb";
            request = "launch";
            program = "\${workspaceFolder}/target/debug/\${workspaceFolderBasename}";
            cwd = "\${workspaceFolder}";
            stopOnEntry = false;
          }
        ];
        go = [
          {
            name = "Launch (delve)";
            type = "delve";
            request = "launch";
            program = "\${workspaceFolder}";
          }
        ];
      };
    };

    extraPackages = with pkgs; [
      delve
      haskellPackages.haskell-debug-adapter
      lldb
    ];
  };
}
