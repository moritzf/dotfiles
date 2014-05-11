" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_openbrowser') && g:loaded_openbrowser
    finish
endif
let g:loaded_openbrowser = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


let s:is_unix = has('unix')
let s:is_mswin = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_macunix = !s:is_mswin && !s:is_cygwin && (has('mac') || has('macunix') || has('gui_macvim') || (!executable('xdg-open') && system('uname') =~? '^darwin'))
lockvar s:is_unix
lockvar s:is_mswin
lockvar s:is_cygwin
lockvar s:is_macunix

if !(s:is_unix || s:is_mswin || s:is_cygwin || s:is_macunix)
    echohl WarningMsg
    echomsg 'Your platform is not supported!'
    echohl None
    finish
endif

" Save booleans for autoload/openbrowser.vim
let g:__openbrowser_platform = {
\   'unix': s:is_unix,
\   'mswin': s:is_mswin,
\   'cygwin': s:is_cygwin,
\   'macunix': s:is_macunix,
\}


" Default values of global variables. "{{{
if g:__openbrowser_platform.cygwin
    function! s:get_default_browser_commands()
        return [
        \   {'name': 'cygstart',
        \    'args': ['{browser}', '{uri}']}
        \]
    endfunction
elseif g:__openbrowser_platform.macunix
    function! s:get_default_browser_commands()
        return [
        \   {'name': 'open',
        \    'args': ['{browser}', '{uri}']}
        \]
    endfunction
elseif g:__openbrowser_platform.mswin
    function! s:get_default_browser_commands()
        return [
        \   {'name': 'rundll32',
        \    'args': 'rundll32 url.dll,FileProtocolHandler {uri}'}
        \]
    endfunction
elseif g:__openbrowser_platform.unix
    function! s:get_default_browser_commands()
        return [
        \   {'name': 'xdg-open',
        \    'args': ['{browser}', '{uri}']},
        \   {'name': 'x-www-browser',
        \    'args': ['{browser}', '{uri}']},
        \   {'name': 'firefox',
        \    'args': ['{browser}', '{uri}']},
        \   {'name': 'w3m',
        \    'args': ['{browser}', '{uri}']},
        \]
    endfunction
endif

" Do not remove g:__openbrowser_platform for debug.
" unlet g:__openbrowser_platform

" }}}

" Global Variables {{{
function! s:valid_commands_and_rules()
    let open_commands = g:openbrowser_open_commands
    let open_rules    = g:openbrowser_open_rules
    if type(open_commands) isnot type([])
        return 0
    endif
    if type(open_rules) isnot type({})
        return 0
    endif
    for cmd in open_commands
        if !has_key(open_rules, cmd)
            return 0
        endif
    endfor
    return 1
endfunction
function! s:convert_commands_and_rules()
    let open_commands = g:openbrowser_open_commands
    let open_rules    = g:openbrowser_open_rules
    let browser_commands = []
    for cmd in open_commands
        call add(browser_commands,{
        \ 'name': cmd,
        \ 'args': open_rules[cmd]
        \})
    endfor
    return browser_commands
endfunction

if !exists('g:openbrowser_browser_commands')
    if exists('g:openbrowser_open_commands')
    \   && exists('g:openbrowser_open_rules')
    \   && s:valid_commands_and_rules()
        " Backward compatibility
        let g:openbrowser_browser_commands = s:convert_commands_and_rules()
    else
        let g:openbrowser_browser_commands = s:get_default_browser_commands()
    endif
endif
if !exists('g:openbrowser_fix_schemes')
    let g:openbrowser_fix_schemes = {
    \   'ttp': 'http',
    \   'ttps': 'https',
    \}
endif
if !exists('g:openbrowser_fix_hosts')
    let g:openbrowser_fix_hosts = {}
endif
if !exists('g:openbrowser_fix_paths')
    let g:openbrowser_fix_paths = {}
endif
if !exists('g:openbrowser_default_search')
    let g:openbrowser_default_search = 'g'
endif

let g:openbrowser_search_engines = extend(
\   get(g:, 'openbrowser_search_engines', {}),
\   {
\       'g': 'http://google.com/search?q={query}',
\       'gcode': 'http://code.google.com/intl/en/query/#q={query}',
\       'py': 'https://www.google.de/search?q={query}+site%3Awww.python.org%2Fdoc%2F',
\       'java' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fdocs.oracle.com%2Fjavase%2F',
\	'js' : 'https://www.google.de/search?q={query}+site%3Ahttps%3A%2F%2Fdeveloper.mozilla.org%2Fen-US%2Fdocs%2FWeb%2FJavascript',
\	'hs' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fwww.haskell.org%2Fhaskellwiki%2F',
\	'rb' : 'https://www.google.de/search?q={query}+site%3Aruby-doc.org%2F%E2%80%8E',
\	'perl' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fperldoc.perl.org%2F',
\	'css' : 'https://www.google.de/search?q={query}+site%3Ahttps%3A%2F%2Fdeveloper.mozilla.org%2Fen-US%2Fdocs%2FWeb%2FCSS',
\	'vim' : 'http://www.google.com/cse?cx=partner-pub-3005259998294962%3Abvyni59kjr1&ie=ISO-8859-1&q={query}&sa=Search&siteurl=www.vim.org%2Fdocs.php',
\	'tex' : 'https://www.google.de/search?q={query}+site%3Aen.wikibooks.org%2Fwiki%2FLaTeX',
\	'texpackages' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fwww.ctan.org%2F',
\	'den' : 'http://www.dict.cc/?s={query}',
\	'dfr' : 'http://defr.dict.cc/?s={query}',
\	'sen' : 'http://thesaurus.com/browse/{query}',
\	'sfr' : 'http://www.conjugation-fr.com/conjugate.php?verb={query}&x=-844&y=-16',
\	'sde' : 'http://www.openthesaurus.de/synonyme/{query}',
\	'wolf': 'http://www.wolframalpha.com/input/?i={query}',
\	'wen' : 'http://en.wikipedia.org/wiki/Special:Search?search={query}',
\	'wde' : 'http://de.wikipedia.org/wiki/Special:Search?search={query}',
\	'c' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fen.cppreference.com%2Fw%2Fc%2F',
\	'cpp' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fen.cppreference.com%2Fw%2Fc%2F',	
\	'pw' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Ftechnet.microsoft.com%2Fen-us%2Flibrary%2F',
\	'bash' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fss64.com%2Fbash%2F',
\	'c#' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fmsdn.microsoft.com%2Fen-us%2Flibrary%2F',
\	'lisp': 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fjtra.cz%2Fstuff%2Flisp%2Fsclr%2F',
\	'prolog' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fwww.swi-prolog.org%2Fpldoc%2F',
\	'octave' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fwww.gnu.org%2Fsoftware%2Foctave%2Fdoc%2Finterpreter%2F',
\	'r' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fwww.rdocumentation.org%2F',
\	'erlang': 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fwww.erlang.org%2F',
\	'clojure' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fclojure.org%2F',
\	'scala' : 'https://www.google.de/search?q={query}+site%3Ahttp%3A%2F%2Fdocs.scala-lang.org%2F',
\},
\   'keep'
\)

if !exists('g:openbrowser_open_filepath_in_vim')
    let g:openbrowser_open_filepath_in_vim = 1
endif
if !exists('g:openbrowser_open_vim_command')
    let g:openbrowser_open_vim_command = 'vsplit'
endif
if !exists('g:openbrowser_short_message')
    let g:openbrowser_short_message = 0
endif
" }}}


" Interfaces {{{

" For backward compatibility,
" - OpenBrowser()
" - OpenBrowserSearch()

" Open URL with `g:openbrowser_open_commands`.
function! OpenBrowser(...) "{{{
    return call('openbrowser#open', a:000)
endfunction "}}}

function! OpenBrowserSearch(...) "{{{
    return call('openbrowser#search', a:000)
endfunction "}}}



" Ex command
command!
\   -nargs=+
\   OpenBrowser
\   call openbrowser#open(<q-args>)
command!
\   -nargs=+ -complete=customlist,openbrowser#_cmd_complete
\   OpenBrowserSearch
\   call openbrowser#_cmd_open_browser_search(<q-args>)
command!
\   -nargs=+ -complete=customlist,openbrowser#_cmd_complete
\   OpenBrowserSmartSearch
\   call openbrowser#_cmd_open_browser_smart_search(<q-args>)



" Key-mapping
nnoremap <silent> <Plug>(openbrowser-open) :<C-u>call openbrowser#_keymapping_open('n')<CR>
vnoremap <silent> <Plug>(openbrowser-open) :<C-u>call openbrowser#_keymapping_open('v')<CR>
nnoremap <silent> <Plug>(openbrowser-search) :<C-u>call openbrowser#_keymapping_search('n')<CR>
vnoremap <silent> <Plug>(openbrowser-search) :<C-u>call openbrowser#_keymapping_search('v')<CR>
nnoremap <silent> <Plug>(openbrowser-smart-search) :<C-u>call openbrowser#_keymapping_smart_search('n')<CR>
vnoremap <silent> <Plug>(openbrowser-smart-search) :<C-u>call openbrowser#_keymapping_smart_search('v')<CR>

" }}}


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
