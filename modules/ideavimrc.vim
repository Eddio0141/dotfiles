set relativenumber
set clipboard=unnamedplus
set smartcase 
set ignorecase

let mapleader = " "

Plug 'machakann/vim-highlightedyank'

set which-key
set notimeout

Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

nmap <S-H> <Action>(PreviousTab)
nmap <S-L> <Action>(NextTab)
nmap <leader>bd <Action>(CloseContent)
nmap <leader>bo <Action>(CloseAllEditorsButActive)

nmap <leader>ca <Action>(ShowIntentionActions)
nmap <leader>cr <Action>(RenameElement)

nmap <leader><space> <Action>(GotoFile)
nmap <leader>/ <Action>(FindInPath)

nmap gI <Action>(GotoImplementation)
nmap gr <Action>(GotoDeclaration)

imap <C-Space> <Action>(EditorChooseLookupItem)

nmap <leader>gg <Action>(ActivateCommitToolWindow)
nmap <leader>e <Action>(ActivateProjectToolWindow)
nmap <leader>r <Action>(SelectInProjectView)

inoremap <c-s> <esc> \| :w<cr>
nnoremap <c-s> <esc> \| :w<cr>

nmap <leader>db <Action>(ToggleLineBreakpoint)
nmap <leader>dc <Action>(Resume)

nmap <c-Up> <Up>
nmap <c-Down> <Down>
nmap <c-Left> <Left>
nmap <c-Right> <Right>
vmap <c-Up> <Up>
vmap <c-Down> <Down>
vmap <c-Left> <Left>
vmap <c-Right> <Right>
imap <c-Up> <Up>
imap <c-Down> <Down>
imap <c-Left> <Left>
imap <c-Right> <Right>

nmap <leader>hr <Action>(Vcs.RollbackChangedLines)

nmap ]e <Action>(ReSharperGotoNextErrorInSolution)
