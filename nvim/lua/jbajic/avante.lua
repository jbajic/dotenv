require("avante_lib").load();

require("avante").setup({
  provider = "gemini", -- Recommend using Claude
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },
  gemini = {
    -- @see https://ai.google.dev/gemini-api/docs/models/gemini
    model = "gemini-2.0-flash",
    temperature = 0,
    max_tokens = 4096,
  },});
