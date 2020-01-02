if exists("tagbar_man_man2ctags_loaded")
    finish
else
    let tagbar_man_man2ctags_loaded = 1
endif

if (!exists('g:tagbar_man_man2ctags'))
    let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
    let g:tagbar_man_man2ctags = s:path . '/../man2ctags.sh'
end

let s:tagbar_type_man = {
            \ 'ctagstype': 'man',
            \ 'ctagsbin' : g:tagbar_man_man2ctags,
            \ 'ctagsargs' : '',
            \ 'kinds' : [
            \   's:Table of contents',
            \ ],
            \ 'sro' : '|',
            \ 'sort': 0,
            \ }

if (!exists('g:tagbar_type_man'))
    let g:tagbar_type_man = copy(s:tagbar_type_man)
endif
