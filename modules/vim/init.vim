let &packpath = &runtimepath

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀
" ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤
"

"Plugins {{{

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

" Treeshitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" Colorschemes
Plug 'bluz71/vim-moonfly-colors'
Plug 'mhartington/oceanic-next'
" File explorer
Plug 'lambdalisue/fern.vim'
" Closing brackets/quotes/... insertion
Plug 'Raimondi/delimitMate'
" Indent guides
Plug 'thaerkh/vim-indentguides'
" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'whiteinge/diffconflicts'
" Markdown support
Plug 'plasticboy/vim-markdown'
" GLSL support
Plug 'tikhomirov/vim-glsl'
" hjson support
Plug 'hjson/vim-hjson'
" pug support
Plug 'digitaltoad/vim-pug'
" Editorconfig
Plug 'editorconfig/editorconfig-vim'
" Prettier
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" LSP
Plug 'neovim/nvim-lspconfig'
" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
"Copilot, disabled by default
Plug 'github/copilot.vim', { 'on': [] }
command! LoadCopilot call plug#load('copilot.vim')
" Parinfer https://shaunlebron.github.io/parinfer, disabled by default
Plug 'eraserhd/parinfer-rust', { 'on': [], 'do': 'cargo build --release' }
command! LoadParinfer call plug#load('parinfer-rust')
" Surrounding
Plug 'machakann/vim-sandwich'

" Initialize plugin system
call plug#end()

" Neovide :)
let g:neovide_cursor_vfx_mode = 'railgun'

" }}}

source ~/.vim/common.vim

"Treesitter {{{

lua <<EOF
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,  -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
  --indent = {
  --  enable = true
  --},
}
EOF

" Treesitter based folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" }}}

"LSP {{{

lua << EOF
local lspconfig = require('lspconfig')
local cmp = require('cmp')

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.get, opts)
vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>N', vim.diagnostic.goto_prev, opts)
--vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  --vim.api.nvim_buf_set_option(bufnr, 'completeopt', 'menuone,noinsert,noselect')
  -- Use <Tab> and <S-Tab> to navigate through popup menu
  --inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  --inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  -- Mappings.
  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  --vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set({'n', 'v'}, '<leader>a', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>=', function() vim.lsp.buf.format{async=true} end, opts)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        "autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        "autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

cmp.setup({
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig['tsserver'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('package.json'),
  single_file_support = false,
  settings = {
    -- https://stackoverflow.com/a/69223288/7683374
    defaultMaximumTruncationLength = 800
  }
})

lspconfig['denols'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc', 'deno.lock')
})

lspconfig['yamlls'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },

    -- to fetch & build schemas
    -- openapi2jsonschema -o outdir --expanded --kubernetes --stand-alone --strict "${schema}"
    -- schema example = https://github.com/openshift/kubernetes/raw/master/api/openapi-spec/swagger.json
    yaml = {
      schemas = {
        kubernetes = '/*',
        --'../jsonschemas/ocp4/all.json' = '/deploy/*',
      },
    },
  }
})

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { 'ccls', 'cssls', 'gopls', 'html', 'jsonls', 'rust_analyzer', 'eslint', 'gdscript', 'cucumber_language_server' }
for _, lang in ipairs(servers) do
  lspconfig[lang].setup({
    capabilities = capabilities,
    on_attach = on_attach
  })
end
EOF

" }}}

" vim: fdm=marker:fdl=0:et:sw=2:
