local cmp = require 'cmp'

local completion_sources =
    cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('Completion', {}),
    callback = function()
        cmp.setup.buffer {
            sources = completion_sources
        }
    end
})


cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    --    sources = cmp.config.sources({
    --        { name = 'nvim_lsp' },
    --        { name = 'luasnip' }, -- For luasnip users.
    --    }, {
    --        { name = 'buffer' },
    --    })
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
