return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    local conform = require('conform')
    local mason_tool_installer = require('mason-tool-installer')

    mason_tool_installer.setup({
      ensure_installed = {
        'stylua',
      },
    })

    conform.setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform will run multiple formatters sequentially
        -- python = { "isort", "black" },
        -- -- Use a sub-list to run only the first available formatter
        -- javascript = { { "prettierd", "prettier" } },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
  end,
}
