if exists('g:vscode')
  " VSCode extension
else
  " install plugins
  call plug#begin("~/.vim/plugged")
    Plug 'junegunn/seoul256.vim'    " My favorite color scheme
    Plug 'dense-analysis/ale'       " For dynamic linting and fixing

    " Syntax highlighting for JavaScript and JSX
    Plug 'pangloss/vim-javascript'
    Plug 'maxmellon/vim-jsx-pretty'

    " For Go :
    " Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

    Plug 'jamessan/vim-gnupg'       " For editing gnupg-encrypted files

    " Plug 'rust-lang/rust.vim'       " For various Rust features. I don't usually use this.
    Plug 'tpope/vim-surround'       " Edit based a richer variety of surrounding things. I don't use it much.
    Plug 'preservim/nerdtree'       " Fancier file browser than netrw. I don't use it much.

    " Collection of common configurations for the Nvim LSP client
    Plug 'neovim/nvim-lspconfig'
    " Completion framework
    Plug 'hrsh7th/nvim-cmp'
    " LSP completion source for nvim-cmp
    Plug 'hrsh7th/cmp-nvim-lsp'
    " Snippet support
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'

    " Plug 'sbdchd/neoformat'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    Plug 'mfussenegger/nvim-jdtls'
    Plug 'vim-airline/vim-airline'

    Plug 'editorconfig/editorconfig-vim'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/nvim-treesitter-context'
  call plug#end()

  lua <<EOF
    local nvim_lsp = require'lspconfig'

    -- Setup Completion
    -- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
    local cmp = require'cmp'
    cmp.setup({
      -- Enable LSP snippets
      snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        })
      },

      -- Installed sources
      sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        --{ name = 'path' },
        { name = 'buffer' },
      },
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- require('rust-tools').setup(opts)

    nvim_lsp.pyright.setup {}

    nvim_lsp.rust_analyzer.setup({
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 200,
      },
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            allTargets = false
          }
        }
      }
    })

    nvim_lsp.clangd.setup({
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 200,
      }
    })

    nvim_lsp.denols.setup {
      root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
    }

    nvim_lsp.tsserver.setup {
      root_dir = nvim_lsp.util.root_pattern("package.json"),
    }

    require'treesitter-context'.setup {}
EOF

  nnoremap <silent> <leader>a    <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <silent> <leader>k    <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> <leader>s    <cmd>lua vim.diagnostic.open_float()<CR>

  "augroup fmt
  "  autocmd!
  "  "autocmd BufWritePre * undojoin | Neoformat
  "  au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  "augroup END

  "˙˙˙˙˙˙˙˙˙˙˙˙˙˙"
  " ALE Settings "
  ".............."

  "" Make \aj and \ak go to next and previous ALE warnings or errors
  "nmap <silent> <leader>aj :ALENext<cr>
  "nmap <silent> <leader>ak :ALEPrevious<cr>
  "
  "" Enable only these ALE linters and fixers
  let g:ale_linters_explicit = 1
  "let g:ale_linters = {
  "\ 'c': ['clangd'],
  "\ 'cpp': ['clangd'],
  "\ 'javascript': ['eslint', 'flow-language-server'],
  "\ 'python': ['autopep8'],
  "\ 'rust': ['analyzer'],
  "\}
  let js_ts_fixers = ['prettier']
  let g:ale_fixers = {
  \ 'cpp': ['astyle'],
  \ 'css': js_ts_fixers,
  \ 'java': ['google_java_format'],
  \ 'javascript': js_ts_fixers,
  \ 'javascriptreact': js_ts_fixers,
  \ 'json': js_ts_fixers,
  \ 'typescript': js_ts_fixers,
  \ 'typescriptreact': js_ts_fixers,
  \ 'python': ['autopep8'],
  \ 'rust': ['rustfmt'],
  \}
  let g:ale_fix_on_save = 1           " Fix on save

  "let g:java_google_java_format_executable = 'java -jar /home/phin/bin/google-java-format-1.15.0-all-deps.jar'
  "let g:ale_lint_on_text_changed = 1  " Lint when text changes, debounced 200 ms (see g:ale_lint_delay)
  "let g:ale_completion_enabled = 1    " Enable autocompletion
  "
  "let g:ale_sign_column_always = 1    " Always show sign column to prevent columns shifting
  "let g:ale_sign_error = 'E'          " Show E for error
  "let g:ale_sign_warning = 'W'        " and W for warning
  "
  "" add dummy sign for ALE column to keep it open in Neovim
  "sign define ALEDummySign text=\ 
  "" set clangtidy options
  "let g:ale_cpp_clangtidy_options = '-Wall -std=c++17 -x c++'
  "" set uncrustify options
  "let g:ale_c_uncrustify_options = ' -c "/home/phin/.uncrustify.cfg"' 
endif

set et sw=2 ts=2                " expand tabs to two spaces
set number                      " show line numbers
set ignorecase                  " ignore case
set smartcase                   " unless capital letters are present
set hlsearch                    " highlight search results

syntax enable                   " enable syntax highlighting
filetype plugin indent on       " enable filetype plugins

let g:seoul256_background = 233 " set seoul colorscheme with darkest background.
color seoul256
set tgc                         " Enable all colors

set scrolloff=3                 " 3 lines of context at top and bottom of screen
set display+=uhex               " Show non-ascii characters as hexadecmial <xx>

" Language-specific settings
autocmd FileType c setlocal shiftwidth=4 tabstop=4
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType java setlocal shiftwidth=4 tabstop=4

" Syntax highlight from the start of file
autocmd BufEnter * :syntax sync fromstart

" Make comments italic
highlight Comment cterm=italic gui=italic

nmap <silent> j gj
nmap <silent> k gk

" Make gl and gh go to left and right tabs
nmap <silent> gl :tabn<cr>
nmap <silent> gh :tabp<cr>
" Treat Ctrl-c like escape
inoremap <C-c> <Esc>
" \<space> to hide search highlighting
nnoremap <silent> <leader><space> :noh<cr>
" \f to open FZF
nnoremap <silent> <leader>f :FZF<cr>
" \<tab> to open nerd tree
nnoremap <silent> <leader><tab> :NERDTreeToggle<cr>
" \c to make the next command use the clipboard register
nnoremap <silent> <leader>c "+
" \tt mark off check boxes in markdown
nnoremap <silent> <leader>tt :s/\[ ]/[x]/<cr>
" Convert a markdown file to PDF using pandoc
nnoremap <silent> <leader>pdf :!to-pdf "%"<cr>
" Open the command line to :n %:p:h/ to open a file in the same folder as the
" current file
nnoremap <nowait> <leader>nn :n %:p:h/

set clipboard+=unnamedplus
set mouse=

nnoremap <C-l> :Files<cr>

" remap SQL omni-completion key to prevent accidental openings
let g:ftplugin_sql_omni_key = '<C-S>'

" open C-related manpages first
let b:man_default_sections = '3,2'

let g:fzf_action = {
      \ 'enter': 'vsplit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-r': 'edit'
  \ }

" let g:neoformat_try_node_exe = 1

" The following blocks define a function that checks if '{{' is anywhere in
" the file, which would be a good indication that it is a Go template file,
" and then sets the filetype for correct syntax highlighting (and to prevent
" Prettier from running on it, for me)
function DetectGoHtmlTmpl()
    if search("{{") != 0
        set filetype=gohtmltmpl 
    endif
endfunction

augroup filetypedetect
    au! BufRead,BufNewFile *.html call DetectGoHtmlTmpl()
augroup END
