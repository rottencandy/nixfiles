-------------------------------------------------------------------------
-- ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀
-- ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤
--

vim.o.packpath = vim.o.runtimepath

-- Plugins {{{

-- Specify a directory for plugins
-- * For Neovim: stdpath('data') . '/plugged'
-- * Avoid using standard Vim directory names like 'plugin'
vim.call('plug#begin', '~/.config/nvim/plugged')
local Plug = vim.fn['plug#']

-- Treeshitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('nvim-treesitter/nvim-treesitter-textobjects')
Plug('nvim-treesitter/nvim-treesitter-context')
-- Colorschemes
Plug('bluz71/vim-moonfly-colors')
-- File explorer
Plug('lambdalisue/fern.vim')
Plug('lambdalisue/vim-fern-hijack')
-- Closing brackets/quotes/... insertion
Plug('Raimondi/delimitMate')
-- Indent guides
Plug('lukas-reineke/indent-blankline.nvim')
-- Git
Plug('tpope/vim-fugitive')
Plug('tpope/vim-rhubarb')
Plug('whiteinge/diffconflicts')
-- pug support
Plug('digitaltoad/vim-pug')
-- Editorconfig
Plug('editorconfig/editorconfig-vim')
-- Formatting
Plug('sbdchd/neoformat')
-- LSP
Plug('neovim/nvim-lspconfig')
-- utils used by plugins
Plug('nvim-lua/plenary.nvim')
-- better tsserver interop
Plug('pmizio/typescript-tools.nvim')
-- Completion
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
-- Snippets
Plug('garymjr/nvim-snippets')
-- Parinfer https://shaunlebron.github.io/parinfer, disabled by default
Plug('eraserhd/parinfer-rust', { ['on'] = {}, ['do'] = 'cargo build --release' })
--command! LoadParinfer call plug#load('parinfer-rust')
-- Surrounding
Plug('machakann/vim-sandwich')

vim.fn['plug#end']()

-- Neovide :)
vim.g.neovide_cursor_vfx_mode = 'railgun'

-- }}}

-- shared config
vim.cmd.source('~/.vim/common.vim')

-- Treesitter {{{

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    -- list of languages that will be disabled
    disable = { },
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
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj
      lookahead = true,
      -- choose the select mode (default is charwise 'v')
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If set to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>]"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>["] = "@parameter.inner",
      },
    },
  },
  lsp_interop = {
    enable = true,
    border = 'none',
    floating_preview_opts = {},
    peek_definition_code = {
        ["<leader>d"] = "@function.outer",
        ["<leader>D"] = "@class.outer",
    },
  },
  indent = {
    enable = true
  },
}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- }}}

-- LSP {{{

local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf=bufnr })
  --vim.api.nvim_buf_set_option(bufnr, 'completeopt', 'menuone,noinsert,noselect')
  -- Use <Tab> and <S-Tab> to navigate through popup menu
  --inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  --inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  -- Mappings.
  local opts = { noremap=true, silent=true, buffer=bufnr }

  vim.keymap.set('n', '<leader>e', vim.diagnostic.get, opts)
  vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>N', vim.diagnostic.goto_prev, opts)
  --vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

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
    vim.api.nvim_exec2([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        "autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        "autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], {})
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('typescript-tools').setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('package.json'),
  single_file_support = false,
  settings = {
    -- do not truncate TS hover definitions
    -- https://stackoverflow.com/a/69223288/7683374
    defaultMaximumTruncationLength = 800,
    noErrorTruncation = true,
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

lspconfig['lua_ls'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      -- skip adding vim runtime if luarc is preset (essentially vim conf check)
      if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { 'ccls', 'cssls', 'gopls', 'html', 'jsonls', 'rust_analyzer', 'eslint', 'gdscript', 'cucumber_language_server', 'svelte', 'nixd' }
for _, lang in ipairs(servers) do
  lspconfig[lang].setup({
    capabilities = capabilities,
    on_attach = on_attach
  })
end

-- }}}

-- Snippets {{{

local snippets = require('snippets')

snippets.setup({
  extended_filetypes = {
    typescript = { 'javascript', 'tsdoc' },
    javascript = { 'jsdoc' },
    html = { 'css', 'javascript' },
    lua = { 'luadoc' },
    sh = { 'shelldoc' },
  },
  search_paths = { vim.env.HOME .. '/.config/snippets' },
})

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.snippet.active({ direction = 1 }) then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  else
    return '<Tab>'
  end
end,
  {
    expr = true,
    silent = true,
  }
)

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if vim.snippet.active({ direction = -1 }) then
    return '<cmd>lua vim.snippet.jump(-1)<cr>'
  else
    return '<S-Tab>'
  end
end,
  {
    expr = true,
    silent = true,
  }
)

-- }}}

-- Completion {{{

local cmp = require('cmp')
cmp.setup()

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
    { name = 'snippets' }, -- snippets
  }, {
    { name = 'buffer' },
  })
})

-- }}}

-- Other {{{

-- indent guides
require("ibl").setup({
  scope = {
    show_start = false,
    show_end = false,
  },
})

-- context
local treesitter_context = require("treesitter-context")

treesitter_context.setup({
  max_lines = 5,
})

vim.keymap.set("n", "<localleader>c", function()
    treesitter_context.go_to_context(vim.v.count1)
  end,
  { silent = true }
)

-- }}}

-- vim: fdm=marker:fdl=0:et:sw=2:
