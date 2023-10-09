return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  dependencies = {
    'williamboman/mason.nvim',
    'jay-babu/mason-null-ls.nvim',
  },
  config = function()
    require('mason-null-ls').setup({
      ensure_installed = {
        'stylua',
        'eslint_d',
        'prettier',
      },
    })

    local null_ls = require('null-ls')
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    local function ts_organize_imports()
      local params = {
        command = '_typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = '',
      }
      vim.lsp.buf.execute_command(params)
    end

    null_ls.setup({
      sources = {
        formatting.stylua,
        diagnostics.eslint_d.with({
          condition = function(utils)
            return utils.root_has_file({ '.eslintrc.js', '.eslintrc.cjs' }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
          end,
        }),
        formatting.prettier,
      },

      -- autoformat on save
      on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              ts_organize_imports()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}
