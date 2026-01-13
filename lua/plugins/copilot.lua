return {
  -- Pure Lua Copilot plugin
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  -- Copilot CMP source
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- You can add custom options here
    },
    -- Set up keymaps after the plugin loads
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      -- Keymaps
      vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat<cr>', { desc = 'Copilot Chat' })
      vim.keymap.set('v', '<leader>cc', ':<C-u>CopilotChat<cr>', { desc = 'Copilot Chat with selection' })
      vim.keymap.set('n', '<leader>ce', '<cmd>CopilotChatExplain<cr>', { desc = 'Copilot - Explain' })
      vim.keymap.set('n', '<leader>ct', '<cmd>CopilotChatTests<cr>', { desc = 'Copilot - Generate Tests' })
    end,
  },
}
