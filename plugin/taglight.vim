" taglight.vim: Highligh tags generated by ctags.
" Author: Paul Meffle
" Version: 0.0.1
" License: MIT License

 augroup Taglight
     autocmd!
     autocmd Syntax cpp call taglight#HighlightTags()
augroup END
