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

-- tree sitter highlights
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "nix", "bash", "html", "typescript", "javascript", "css", "svelte", "markdown" },
	callback = function()
		-- enable folds
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		-- enable indentation
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		-- start ts
		vim.treesitter.start()
	end,
})

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

		-- telescope {{{

		{
			"nvim-telescope/telescope.nvim",
			version = "*",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"Marskey/telescope-sg",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			},
			config = function()
				local telescope = require("telescope")
				local builtin = require("telescope.builtin")
				local actions = require("telescope.actions")
				local action_layout = require("telescope.actions.layout")
				local ast_grep = telescope.load_extension("ast_grep")
				telescope.setup({
					defaults = {
						mappings = {
							i = {
								["<C-u>"] = false,
								["<C-k>"] = action_layout.toggle_preview,
								["<c-b>"] = actions.delete_buffer,
							},
							n = {
								["<C-u>"] = false,
								["<C-k>"] = action_layout.toggle_preview,
								["<c-b>"] = actions.delete_buffer,
							},
						},
					},
					pickers = {},
					extensions = {
						ast_grep = {
							command = {
								"ast-grep",
								"--json=stream",
							},
							grep_open_files = false,
							lang = nil,
						},
					},
				})
				vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
				vim.keymap.set({ "n", "v" }, "<leader>s", builtin.live_grep, { desc = "Telescope live grep" })
				vim.keymap.set({ "n", "v" }, "<leader>S", ast_grep.ast_grep, { desc = "Telescope ast-grep search" })
				vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
			end,
		},

		-- }}}

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
						http = {
							kat_coder = function()
								return require("codecompanion.adapters").extend("openai_compatible", {
									env = {
										url = "https://openrouter.ai/api",
										api_key = "cmd:gpg --batch --quiet --decrypt ~/code/misc/api/openrouter_api_key.gpg",
									},
									headers = {
										["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim",
									},
									schema = {
										model = {
											default = "kwaipilot/kat-coder-pro:free",
										},
									},
								})
							end,
							qwen3 = function()
								return require("codecompanion.adapters").extend("openai_compatible", {
									env = {
										url = "https://openrouter.ai/api",
										api_key = "cmd:gpg --batch --quiet --decrypt ~/code/misc/api/openrouter_api_key.gpg",
									},
									headers = {
										["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim",
									},
									schema = {
										model = {
											default = "qwen/qwen3-coder:free",
										},
									},
								})
							end,
						},
						acp = {
							claude_code = function()
								return require("codecompanion.adapters").extend("claude_code", {
									env = {
										CLAUDE_CODE_OAUTH_TOKEN = "cmd:gpg --batch --quiet --decrypt ~/code/misc/api/claude_api_key.gpg",
									},
								})
							end,
						},
					},
					strategies = {
						chat = {
							adapter = "claude_code",
						},
						inline = {
							adapter = "kat_coder",
						},
					},
					display = {
						chat = {
							show_settings = false,
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
			dependencies = { "nvim-lua/plenary.nvim" },
			branch = "main",
			lazy = false,
			build = ":TSUpdate",
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
					root_markers = { "package.json" },
					single_file_support = false,
					settings = {
						-- do not truncate TS hover definitions
						-- https://stackoverflow.com/a/69223288/7683374
						defaultMaximumTruncationLength = 800,
						noErrorTruncation = true,
					},
				})

				vim.lsp.enable("denols")
				vim.lsp.config("denols", {
					root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
				})

				vim.lsp.enable("yamlls")
				vim.lsp.config("yamlls", {
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

				vim.lsp.enable("lua_ls")
				vim.lsp.config("lua_ls", {
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

				vim.lsp.enable("nixd")
				vim.lsp.config("nixd", {
					settings = {
						nixd = {
							formatting = {
								command = { "nixfmt" },
							},
						},
					},
				})

				vim.lsp.enable({
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
				})
				vim.lsp.config("*", {
					capabilities = capabilities,
					on_attach = on_attach,
				})
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
