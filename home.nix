{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "saud";
  home.homeDirectory = "/home/saud";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    delta
    vim
    neovim
    emacs
    helix
    tmux
    neofetch
    xh
    fd
    nnn
    broot
    bottom
    htop
    lsd
    wget
    curl
    jq
    jless
    yt-dlp

    wineWowPackages.waylandFull
    winetricks
    bottles

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".tmux.conf".source = ./home/tmux.conf;
    ".config/sway/config".source = ./home/sway.config;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/saud/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    NNN_TMPFILE = "/tmp/.nnn-lastd";
  };

  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  programs.bash.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    tmux.enableShellIntegration = true;
  };

  # kanshi, ripgrep does not exist on stable branch of home-manager yet :/

  #programs.kanshi = {
  #  enable = true;
  #  profiles = {
  #    default = {
  #      outputs = {
  #        "HDMI-A-1" = {
  #          mode = "1920x1080@74.973";
  #          position = "0,0";
  #        };
  #        "eDP-1" = {
  #          position = "1920,0";
  #        };
  #      };
  #    };
  #    default2 = {
  #      outputs = {
  #        "HDMI-A-2" = {
  #          mode = "1920x1080@74.973";
  #          position = "0,0";
  #        };
  #        "eDP-1" = {
  #          position = "1920,0";
  #        };
  #      };
  #    };
  #  };
  #};

  #programs.ripgrep = {
  #  enable = true;
  #  arguments = [
  #    "--smart-case"
  #    #"--hidden"
  #    "--glob"
  #    "!.git"
  #  ];
  #};

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
      pr = "!f() { git fetch upstream pull/\${1}/head:pr\${1}; }; f";

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
    # TODO: turn this to attr set
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
        conflictstyle = "diff3";
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

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
