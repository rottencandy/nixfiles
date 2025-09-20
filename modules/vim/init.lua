-------------------------------------------------------------------------
-- ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀
-- ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤
--

vim.o.packpath = vim.o.runtimepath

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Neovide :)
vim.g.neovide_cursor_vfx_mode = "railgun"

-- shared config
vim.cmd.source("~/.vim/common.vim")

-- LSP Mappings
local lspOpts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>e", vim.diagnostic.get, lspOpts)
vim.keymap.set("n", "<leader>n", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, lspOpts)
vim.keymap.set("n", "<leader>N", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, lspOpts)
--vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, lspOpts)

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, lspOpts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, lspOpts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, lspOpts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, lspOpts)
--vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, lspOpts)
--vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, lspOpts)
--vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, lspOpts)
--vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, lspOpts)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, lspOpts)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, lspOpts)
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, lspOpts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, lspOpts)
vim.keymap.set("n", "<leader>=", function()
	vim.lsp.buf.format({ async = true })
end, lspOpts)

require("lazy").setup({
	lockfile = "~/nix/modules/vim/lazy-lock.json",
	spec = {
		rocks = {
			enabled = false,
		},

		-- Local
		--{
		--	name = "llm",
		--	dir = "~/code/vim/llm.nvim",
		--	opts = {},
		--	dependencies = { "nvim-lua/plenary.nvim" },
		--},

		-- fzf
		{ name = "fzf", dir = "@@FZF_PLUGIN_PATH@@", lazy = false },

		-- Colorschemes
		{
			"bluz71/vim-moonfly-colors",
			config = function()
				vim.cmd([[colorscheme moonfly]])
			end,
		},

		-- File explorer
		{ "lambdalisue/fern.vim" },
		{ "lambdalisue/vim-fern-hijack" },

		-- Closing brackets/quotes/... insertion
		{ "Raimondi/delimitMate", event = "InsertEnter" },

		-- Parinfer https://shaunlebron.github.io/parinfer
		--{"eraserhd/parinfer-rust", build = "cargo build --release"}
		-- Surrounding
		{ "machakann/vim-sandwich", event = "InsertEnter" },

		-- Indent guides
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			opts = {
				scope = {
					show_start = false,
					show_end = false,
				},
			},
		},

		-- Git
		{ "tpope/vim-fugitive" },
		{ "tpope/vim-rhubarb", dependencies = { "tpope/vim-fugitive" } },
		{ "whiteinge/diffconflicts" },

		-- pug support
		--{'digitaltoad/vim-pug'},
		-- Editorconfig
		{ "editorconfig/editorconfig-vim" },

		-- Formatting
		{ "sbdchd/neoformat" },

		-- better tsserver interop
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {},
		},

		-- code companion {{{

		{
			"olimorris/codecompanion.nvim",
			config = function()
				require("codecompanion").setup({
					adapters = {
						deepseek_r1 = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
								},
								headers = {
									["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim",
								},
								schema = {
									model = {
										default = "deepseek/deepseek-r1:free",
									},
								},
							})
						end,
						kimi_dev = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
								},
								headers = {
									["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim",
								},
								schema = {
									model = {
										default = "moonshotai/kimi-dev-72b:free",
									},
								},
							})
						end,
						qwen_qwq = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
								},
								headers = {
									["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim",
								},
								schema = {
									model = {
										default = "qwen/qwq-32b:free",
									},
								},
							})
						end,
					},
					strategies = {
						chat = {
							adapter = "kimi_dev",
						},
						inline = {
							adapter = "kimi_dev",
						},
					},
					display = {
						chat = {
							show_settings = true,
						},
					},
				})
			end,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
			keys = {
				{ "<C-c>", "<cmd>CodeCompanionChat Toggle<CR>", mode = "n", desc = "Toggle chat window." },
				{ "<C-c>", "<cmd>CodeCompanionChat Add<CR>", mode = "v", desc = "Send selection to chat window." },
				{ "<C-s>", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "Toggle actions dialog." },
				{ "<C-s>", "<cmd>CodeCompanionActions<CR>", mode = "v", desc = "Toggle actions dialog." },
			},
		},

		-- }}}

		-- Treesitter {{{

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					highlight = {
						enable = true,
						-- list of languages that will be disabled
						disable = {},
					},
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "<CR>",
							node_incremental = "<CR>",
							scope_incremental = "<TAB>",
							node_decremental = "<S-TAB>",
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
								["@parameter.outer"] = "v", -- charwise
								["@function.outer"] = "V", -- linewise
								["@class.outer"] = "<c-v>", -- blockwise
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
						border = "none",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>d"] = "@function.outer",
							["<leader>D"] = "@class.outer",
						},
					},
					indent = {
						enable = true,
					},
				})
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				max_lines = 5,
			},
			config = function()
				local treesitter_context = require("treesitter-context")

				treesitter_context.setup({
					max_lines = 5,
				})

				vim.keymap.set("n", "<localleader>c", function()
					treesitter_context.go_to_context(vim.v.count1)
				end, { silent = true })
			end,
		},
		{ "nvim-treesitter/nvim-treesitter-textobjects" },

		-- }}}

		-- LSP {{{

		{
			"neovim/nvim-lspconfig",
			config = function()
				local on_attach = function(client, bufnr)
					vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
					--vim.api.nvim_buf_set_option(bufnr, 'completeopt', 'menuone,noinsert,noselect')
					-- Use <Tab> and <S-Tab> to navigate through popup menu
					--inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
					--inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

					-- Set autocommands conditional on server_capabilities
					if client.server_capabilities.document_highlight then
						vim.api.nvim_exec2(
							[[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        "autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        "autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
							{}
						)
					end
				end

				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				require("typescript-tools").setup({
					capabilities = capabilities,
					on_attach = on_attach,
					root_markers = { "package.json" },
					single_file_support = false,
					settings = {
						-- do not truncate TS hover definitions
						-- https://stackoverflow.com/a/69223288/7683374
						defaultMaximumTruncationLength = 800,
						noErrorTruncation = true,
					},
				})

				vim.lsp.config("denols", {
					capabilities = capabilities,
					on_attach = on_attach,
					root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
				})

				vim.lsp.config("yamlls", {
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
								kubernetes = "/*",
								--'../jsonschemas/ocp4/all.json' = '/deploy/*',
							},
						},
					},
				})

				vim.lsp.config("lua_ls", {
					capabilities = capabilities,
					on_attach = on_attach,
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							-- skip adding vim runtime if luarc is preset (essentially vim conf check)
							if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- Depending on the usage, you might want to add additional paths here.
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
								-- library = vim.api.nvim_get_runtime_file("", true)
							},
						})
					end,
					settings = {
						Lua = {},
					},
				})

				vim.lsp.config("nixd", {
					settings = {
						nixd = {
							formatting = {
								command = { "nixfmt" },
							},
						},
					},
				})

				-- Use a loop to conveniently both setup defined servers
				-- and map buffer local keybindings when the language server attaches
				local servers = {
					"ccls",
					"cssls",
					"gopls",
					"html",
					"jsonls",
					"rust_analyzer",
					"eslint",
					"gdscript",
					"cucumber_language_server",
					"svelte",
					"basedpyright",
				}
				for _, lang in ipairs(servers) do
					vim.lsp.config(lang, {
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end
			end,
		},

		-- }}}

		-- Completion {{{

		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline" },
			config = function()
				local cmp = require("cmp")

				cmp.setup({
					window = {
						-- completion = cmp.config.window.bordered(),
						-- documentation = cmp.config.window.bordered(),
					},
					mapping = cmp.mapping.preset.insert({
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "snippets" }, -- snippets
					}, {
						{ name = "buffer" },
					}),
				})
			end,
		},

		-- }}}

		-- Snippets {{{

		{
			"garymjr/nvim-snippets",
			opts = {
				extended_filetypes = {
					typescript = { "javascript", "tsdoc" },
					javascript = { "jsdoc" },
					html = { "css", "javascript" },
					lua = { "luadoc" },
					sh = { "shelldoc" },
				},
				search_paths = { vim.env.HOME .. "/.config/snippets" },
			},
			keys = {
				{
					"<Tab>",
					function()
						if vim.snippet.active({ direction = 1 }) then
							return "<cmd>lua vim.snippet.jump(1)<cr>"
						else
							return "<Tab>"
						end
					end,
					mode = { "i", "s" },
					expr = true,
					silent = true,
				},
				{
					"<S-Tab>",
					function()
						if vim.snippet.active({ direction = -1 }) then
							return "<cmd>lua vim.snippet.jump(-1)<cr>"
						else
							return "<S-Tab>"
						end
					end,
					mode = { "i", "s" },
					expr = true,
					silent = true,
				},
			},
		},

		-- }}}
	},
})

-- vim: fdm=marker:fdl=0:sw=4:
