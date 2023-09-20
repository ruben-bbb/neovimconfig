-- performance
vim.o.lazyredraw = true
vim.o.ttimeout = true
vim.o.ttimeoutlen = 50

-- indentation
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.tabstop = 4

-- movement
vim.o.scrolloff = 7
vim.g.mapleader = ","

-- ui
vim.o.wildmenu = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.hidden = true
vim.o.laststatus = 2
vim.o.display = 'lastline'
vim.o.showmode = true
vim.o.showcmd = true
vim.o.showmatch = true
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    pattern = '*',
    command = 'silent! normal! g`"zv'
})

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 25

-- search
vim.o.incsearch = true
vim.o.hlsearch = true

-- colours
vim.o.spelllang = 'en_au'
vim.cmd.colorscheme 'sonokai'
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.md" },
    command = "setlocal spell spelllang=en_au"
})

-- treesitter
require 'nvim-treesitter.configs'.setup {
    auto_install = true,
    highlight = { enable = true },
    additional_vim_regex_highlighting = false
}

-- lsp
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name)  -- default handler (optional)
        require("lspconfig")[server_name].setup {
            capabilities = require('cmp_nvim_lsp').default_capabilities()
        }
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["rust_analyzer"] = function()
        require("rust-tools").setup {}
    end
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
