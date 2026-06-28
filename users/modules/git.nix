{...}: {
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
}
