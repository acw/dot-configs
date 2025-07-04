require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "openai",
    },
    inline = {
      adapter = "openai",
    },
  },
  adapters = {
    openai = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = "https://openrouter.ai/api",
          api_key = "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",
          chat_url = "/v1/chat/completions",
        },
        schema = {
          model = {
            default = "qwen/qwen3-30b-a3b:free",
          },
        },
      })
    end,
   },
})
