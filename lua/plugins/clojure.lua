-- ------------------------------------------
-- Clojure Development support - overrides & extra config
--
-- community.lua includes the AstroCommunity Clojure Pack
--
-- Override or add Clojure releated plugins & configuration here
-- ------------------------------------------

if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Local variables
-- Language filetypes for plugins
local lisp_dialects = { "clojure", "fennel" }

---@type LazySpec
return {
  -- Ensure Language Server installed
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "clojure_lsp" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "clojure-lsp" })
    end,
  },
  -- Treesitter Clojure parser
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "clojure" })
      end
    end,
  },

  -- Structural Editing
  -- Parinfer Alignment driven structured editing for Clojure and more
  -- ["clojure", "scheme", "lisp", "racket", "hy", "fennel", "janet", "carp", "wast", "yuck"]
  {
    "gpanders/nvim-parinfer",
    filetype = lisp_dialects,
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        indent = {
          -- fix indentation of nodes operated upon
          -- enabled = false,
          -- custom indentation function called after a slurp/barf
          -- indentor = require("nvim-paredit.indentation.native").indentor,
        },
        options = {
          g = {
            parinfer_force_balance = true,
            parinfer_comment_chars = { ";", ";;" },
            -- "smart", "indent" or "paren" mode - https://shaunlebron.github.io/parinfer/#writing-with-parinfer
            parinfer_mode = "smart",
          },
        },
        keys = {
          -- Toggle Parinfer on/off (globally)
          { "<leader>TP", "<cmd>ParinferOn! <cr>", desc = "Toggle Parinfer" },
        },
      },
    },
  },
  -- Paredit paren wrangling
  {
    "julienvincent/nvim-paredit",
    filetype = lisp_dialects,
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {},
        },
      },
    },
  },
  -- Paredit & Parinfer together
  {
    "dundalek/parpar.nvim",
    filetype = lisp_dialects,
    dependencies = {
      "AstroNvim/astrocore",
      "gpanders/nvim-parinfer",
      "julienvincent/nvim-paredit",
      opts = {
        options = {
          g = {},
        },
      },
    },
  },
  -- Treesitter structural editing
  {
    "PaterJason/nvim-treesitter-sexp",
    filetype = lisp_dialects,
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        -- configuration:
        -- https://github.com/PaterJason/nvim-treesitter-sexp#configuration
        enabled = false,
        set_cursor = true,
        -- keymaps = {
        --   commands = {
        --   },
        options = {
          g = {},
        },
        mappings = {
          n = {
            -- Additional Which-key key bindings for nvim-treesitter-sexp
            ["<leader>k"] = { name = "Structural Editing" },
            ["<leader>kE"] = { "<cmd>TSSexp swap_prev_elem<cr>", desc = "Swap Previous Element" },
            ["<leader>ke"] = { "<cmd>TSSexp swap_next_elem<cr>", desc = "Swap Previous Element" },
            ["<leader>kF"] = { "<cmd>TSSexp swap_prev_form<cr>", desc = "Swap Previous Form" },
            ["<leader>kf"] = { "<cmd>TSSexp swap_next_form<cr>", desc = "Swap Previous Form" },
            ["<leader>kk"] = { "<cmd>TSSexp promote_elem<cr>", desc = "Promote Element" },
            ["<leader>kr"] = { "<cmd>TSSexp promote_form<cr>", desc = "Promote Form" },
            ["<leader>k@"] = { "<cmd>TSSexp splice<cr>", desc = "Splice" },
            ["<leader>kS"] = { "<cmd>TSSexp slurp_left<cr>", desc = "Slurp Left" },
            ["<leader>ks"] = { "<cmd>TSSexp slurp_right<cr>", desc = "Slurp Right" },
            ["<leader>kB"] = { "<cmd>TSSexp barf_left<cr>", desc = "Barf Left" },
            ["<leader>kb"] = { "<cmd>TSSexp barf_right<cr>", desc = "Barf Right" },
            ["<leader>kI"] = { "<cmd>TSSexp barf_right<cr>", desc = "Insert Head" },
            ["<leader>ki"] = { "<cmd>TSSexp barf_right<cr>", desc = "Insert Tail" },
          },
          t = {
            -- terminal? mode key bindings
          },
          v = {
            -- visual mode key bindings
          },
        },
      },
    },
  },
  -- REPL workflow with Conjure
  {
    "Olical/conjure",
    -- load plugin on filetypes
    filetype = lisp_dialects,
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        autocmds = {
          conjure_log_disable_lsp = {
            {
              event = "BufNewFile",
              pattern = { "conjure-log-*" },
              callback = function() vim.diagnostic.disable(0) end,
              desc = "Conjure Log disable LSP diagnostics",
            },
            {
              event = "FileType",
              pattern = { "clojure" },
              callback = function() vim.bo.commentstring = ";; %s" end,
              desc = "Lisp style line comment",
            },
            -- ClojureDart Filetype works, but syntax highlight not working
            -- {
            --   event = { "BufNewFile", "BufRead", "FileType" },
            --   pattern = { "*.cljd" },
            --   callback = function() vim.filetype.add { "clojure" } end,
            --   desc = "Set ClojureDart extension as Clojure filetype",
            -- },
          },
        },
        options = {
          g = {
            -- Width of HUD as percentage of the editor width between 0.0 and 1.0. Default: `0.42`
            ["conjure#log#hud#width"] = 1,
            -- Display HUD (REPL log). Default: `true`
            ["conjure#log#hud#enabled"] = false,
            -- HUD corner position (over-ridden by HUD cursor detection). Default: `"NE"`
            -- Example: Set to `"SE"` and HUD width to `1.0` for full width HUD at bottom of screen
            ["conjure#log#hud#anchor"] = "SE",
            -- Open log at bottom or far right of editor, using full width or height. Default: `false`
            ["conjure#log#botright"] = true,
            -- Lines from top of file to check for `ns` form, to sett evaluation context Default: `24`
            -- `b:conjure#context` to override a specific buffer that isn't finding the context
            ["conjure#extract#context_header_lines"] = 100,
            ["conjure#eval#comment_prefix"] = ";; ",
            -- Start "auto-repl" process when nREPL connection not found, e.g. babashka. ;; Default: `true`
            ["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false,
            -- Hide auto-repl buffer when triggered. Default: `false`
            ["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true,
            -- Command to start the auto-repl. Default: `"bb nrepl-server localhost:8794"`
            ["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = nil,
            -- Ensure namespace required after REPL connection. Default: `true`
            ["conjure#client#clojure#nrepl#eval#auto_require"] = false,
            -- suppress `; (out)` prefix in log evaluation results
            ["conjure#client#clojure#nrepl#eval#raw_out"] = true,
            -- test runner "clojure" (clojure.test) "clojurescript" (cljs.test) "kaocha"
            ["conjure#client#clojure#nrepl#test#runner"] = "clojure",
          },
        },
      },
    },
  },
}
