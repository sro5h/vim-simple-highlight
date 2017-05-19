let s:script_path = expand('<sfile>:p:h:h')

function! HighlightTags()
    let temp_file = tempname()
    let output = system(s:script_path . '/shell/gen.bash > ' . l:temp_file)
    execute "source " . l:temp_file
endfunction
