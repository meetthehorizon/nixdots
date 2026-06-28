{pkgs, ...}: {
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

      signing = {
        key = "3A95CB5B608EA1CA";
        signByDefault = true;
      };

      core.editor = "nvim";
      init.defaultBranch = "master";
      pull.rebase = true;
      "url \"git@github.com:\"".insteadOf = "https://github.com/";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
