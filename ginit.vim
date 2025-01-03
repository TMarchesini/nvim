" Copy to nvim folder
call rpcnotify(0, 'Gui', 'WindowMaximized', 1)

" Set font in gui
" set guifont=Consolas:h11
set guifont=FiraCode\ Nerd\ Font\ Mono:h11
" set guifont=FiraCode\ Nerd\ Font:h11 " This is not a fixed pitch font, whatever that means
" set guifont=DejaVu\ Sans\ Mono:h14

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})
augroup END
