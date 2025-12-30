-- OpenRouter setup for llm.nvim
require("llm.providers.openrouter").setup({
  api_key = vim.env.OPENROUTER_API_KEY,
  default_model = "qwen/qwen3-235b-a3b-instruct",   -- Qwen3-Coder for best coding performance
})