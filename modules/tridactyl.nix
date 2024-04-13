{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.file = {
    ".config/tridactyl/tridactylrc".text = ''

      " Search engines

      set searchurls.runnaroo https://runnaroo.com/first-rule-of-fightclub?term=%s
      set searchurls.g https://google.com/search?hl=en&q=%s
      set searchurls.d https://duckduckgo.com/?q=%s
      set searchurls.y https://youtube.com/results?search_query=%s
      set searchurls.b https://search.brave.com/search?q=%s

      setnull searchurls.github

      set searchengine runnaroo

      " Quickmarks

      quickmark m https://mail.google.com
      quickmark s https://coreos.slack.com

      " Binds

      " Create new window with tab
      bind gd tabdetach

      " Site-specific binds

      " disable some mappings in gmail
      unbindurl ^https://mail.google.com j
      unbindurl ^https://mail.google.com k
      unbindurl ^https://mail.google.com gi

      unbindurl ^https://youtube.com f

      " Git{Hub,Lab} git clone via SSH yank
      bind yg composite js "git clone " + document.location.href.replace(/https?:\/\//,"git@").replace("/",":").replace(/$/,".git") | clipboard yank

      " Comment toggler for Reddit, Hacker News and Lobste.rs
      bind ;c hint -Jc [class*="expand"],[class*="togg"],[class="comment_folder"]

      " Make gu take you back to subreddit from comments
      bindurl reddit.com gu urlparent 4

      " Video id yank
      bindurl youtube.com yt composite js document.location.href.split('=')[1] | clipboard yank

      "autocontain -s youtube\.com Personal

      " Site-specific config

      " Suspend / discard all tabs (except currently active ones)
      command discardall jsb browser.tabs.query({}).then(ts => browser.tabs.discard(ts.map(t=>t.id)))

      " Always use old reddit
      autocmd DocStart ^http(s?)://www.reddit.com js tri.excmds.urlmodify("-t", "www", "old") 

      " Ignored sites

      "blacklistadd ^https://mail.google.com
      blacklistadd ^https://meet.google.com
      blacklistadd ^https://docs.google.com
      blacklistadd ^https://bluejeans.com
      blacklistadd ^https://monkeytype.com
      set leavegithubalone true
    '';
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
