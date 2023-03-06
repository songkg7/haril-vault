"" Source your .vimrc
source ~/.vimrc

Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'

let mapleader=" "
map <Leader> <Plug>(easymotion-prefix)
nmap <Leader>l <Plug>(easymotion-lineforward)
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader>h <Plug>(easymotion-linebackward)
nmap <Leader>a <Plug>(easymotion-jumptoanywhere)
nmap <Leader>e <Plug>(easymotion-e)
nmap \f :NERDTreeFind<CR>

"" -- Suggested options --
" Show a few lines of context around the cursor. Note that this makes the
" text scroll if you mouse-click near the start or end of the window.

set scrolloff=5
set surround
set commentary
set NERDTree
set multiple-cursors
set easymotion
set hlsearch
set cb=unnamed
set visualbell
" Do incremental searching.
set incsearch

" 아래 mapping 은 같은 기능을 한다.
nmapsymotion-prefix <Tab>f <Action>(QuickFixes)
" nnoremap <Tab>f :action QuickFixes<CR>
nmap <Tab>c <Action>(ChangesView.NewChangeList)

" Don't use Ex mode, use Q for formatting.
map Q gq
map <C-N>  <A-N>
map <C-P>  <A-P>
map <C-X>  <A-X>
map g<C-N> g<A-N>
map <C-C> :noh <CR>

"" -- Map IDE actions to IdeaVim -- https://jb.gg/abva4t
"" Map \r to the Reformat Code action
"map \r <Action>(ReformatCode)


"" Map \b to toggle the breakpoint on the current line
map \b <Action>(ToggleLineBreakpoint)
nmap <C-[> gT
nmap <C-]> gt
nmap <Tab>hw <Action>(HideAllWindows)
nmap <Tab>to <C-w>o<CR>:tabonly<CR>

" Find more examples here: https://jb.gg/share-ideavimrc
set ideajoin
set clipboard+=ideaput
