"
" taglight.vim
"
" Author:
"     Paul Meffle
"
" Summary:
"     Highlight tags generated by ctags.
"
" License:
"     Zlib license

augroup Taglight
        autocmd!
        autocmd Syntax cpp call taglight#HighlightTags()
        autocmd BufWritePost *.cpp,*.hpp,*.h call taglight#HighlightTags()
augroup END
