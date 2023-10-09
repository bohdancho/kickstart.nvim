return {
  'ggandor/leap.nvim',
  dependencies = {
    'tpope/vim-repeat',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('leap').add_default_mappings()
  end,
}
