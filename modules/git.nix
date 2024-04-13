{
  config,
  lib,
  pkgs,
  ...
}:

let
  git-glog = pkgs.writeShellScriptBin "glog" ''
    setterm -linewrap off

    git --no-pager log --all --color=always --graph --abbrev-commit --decorate \
        --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' | \
        sed -E \
        -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+ /├\1─_\2/' \
        -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m /\1├─_\x1b\[m/' \
        -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+/├\1_\2/' \
        -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m/\1├_\x1b\[m/' \
        -e 's/_(\x1b\[[0-9;]*m)+\\/_\1__/' \
        -e 's/_(\x1b\[[0-9;]*m)+\//_\1__/' \
        -e 's/(\||\\)\x1b\[m   (\x1b\[[0-9;]*m)/__\2/' \
        -e 's/(\x1b\[[0-9;]*m)\\/\1_/g' \
        -e 's/(\x1b\[[0-9;]*m)\//\1_/g' \
        -e 's/^\*|(\x1b\[m )\*/\1_/g' \
        -e 's/(\x1b\[[0-9;]*m)\|/\1│/g' \
        | command less -r +'/[^/]HEAD'

    setterm -linewrap on
  '';
in
{
  home.packages = with pkgs; [
    git
    git-glog
  ];

  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        "side-by-side" = true;
        "line-numbers" = true;
        navigate = true;
      };
    };
    userName = "Mohammed Saud";
    userEmail = "md.saud020@gmail.com";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      last = "log -1 HEAD";
      yoink = "reset --hard";
      # All unmerged commits after fetch
      lc = "log ORIG_HEAD.. --stat --no-merges";

      # log in local time
      llog = "log --date=local";

      # Fetch PR from upstream
      pr = "!f() { git fetch origin pull/\${1}/head:pr\${1}; }; f";

      # Pretty log
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";

      # Show current branch
      pwd = "symbolic-ref --short HEAD";
      # Show corresponding upstream branch
      upstream = "name-rev @{upstream}";

      # Set upstream before pushing if necessary
      pu = "!f() { if [ \"$(git upstream 2> /dev/null)\" ]; then git push; else git push -u origin $(git pwd); fi }; f";

      # Pull submodules
      pulsub = "submodule update --remote";
    };
    extraConfig = {
      # colorize output
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        interactive = "auto";
        ui = true;
        pager = true;
      };
      # cache credentials
      credential = {
        helper = "cache --timeout=3600";
      };
      merge = {
        conflictstyle = "zdiff3";
        tool = "nvim -d";
      };
      sendemail = {
        smtpEncryption = "tls";
        smtpServer = "smtp.gmail.com";
        smtpServerPort = "587";
        smtpUser = "md.saud020@gmail.com";
      };
      pull.rebase = true;
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      init.defaultBranch = "main";
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
