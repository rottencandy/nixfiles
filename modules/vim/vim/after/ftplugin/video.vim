" Open detected media files appropriately
silent execute "!mpv " . shellescape(expand("%:p")) . " &>/dev/null &" | buffer# | bdelete# | redraw! | syntax on
