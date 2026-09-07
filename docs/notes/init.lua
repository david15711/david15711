vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.termguicolors = true
vim.syntax = true

-- 1. Lazy.nvim 플러그인 매니저 부트스트랩
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. 플러그인 설치 및 설정
require("lazy").setup({
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "clangd", "lua_ls" },
      automatic_installation = true,
      handlers = {
        -- 설치된 모든 LSP 서버에 대해 기본 활성화
        function(server_name)
          vim.lsp.enable(server_name)
        end,
        -- 커스텀 옵션이 필요한 서버는 커스텀 핸들러 지정
        ["clangd"] = function()
          vim.lsp.config('clangd', {
            cmd = { 'clangd', '--background-index', '--clang-tidy' },
          })
          vim.lsp.enable('clangd')
        end,
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
  },
  { "hrsh7th/cmp-path", },
  { "L3MON4D3/LuaSnip" },
  {
    "nvim-treesitter/nvim-treesitter",
    -- branch = "main",
    build = ":TSUpdate",
    ensure_installed = {'c', 'cpp', 'json', 'lua', 'markdown', 'vim', 'xml', 'yaml'},
    highlight = {
      enable = true,
    }
  },
  {
    "hedyhli/outline.nvim",
    event = "VeryLazy",
    cmd = { "Outline" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        position = 'left',
      },

      outline_items = {
        show_symbol_lineno = true,
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd[[colorscheme catppuccin]]
      vim.cmd[[highlight LineNr guifg=#EEEEAA]]
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  {
    "nvim-mini/mini.icons",
    version = '*',
    config = true,
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    event = "VeryLazy",
    opts = { },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "helix", },
    keys = {
      {
        "<leader>?", function() require("which-key").show({ global = false }) end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  {
    "folke/todo-comments.nvim", -- dependencies = { ripgrep, TODO: install ripgrep}
    cmd = { "TodoTrouble", }, -- "TodoTelescope" },
    event = "VeryLazy",
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)", },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)", },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)", },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)", },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)", },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  {
    "folke/snacks.nvim", -- dependencies = { fdfind, TODO: install sharkdp.fd }
    opts = {
      explorer = { enabled = true },
      picker = {
        files = {
          cmd = "fd",
          hidden = true,
        },
      },
    },
    keys = {
      { "<leader>e", function() require("snacks").explorer() end, desc = "File Explorer" },
      -- Top Pickers & Explorer
      { "<leader><space>", function() require("snacks").picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() require("snacks").picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() require("snacks").picker.grep() end, desc = "Grep" },
      { "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() require("snacks").picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() require("snacks").explorer() end, desc = "File Explorer" },
      -- find
      { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() require("snacks").picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() require("snacks").picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent" },
      -- git
      { "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() require("snacks").picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() require("snacks").picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() require("snacks").picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() require("snacks").picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() require("snacks").picker.git_log_file() end, desc = "Git Log File" },
      -- gh
      { "<leader>gi", function() require("snacks").picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI", function() require("snacks").picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() require("snacks").picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() require("snacks").picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
      -- Grep
      { "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() require("snacks").picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() require("snacks").picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() require("snacks").picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() require("snacks").picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() require("snacks").picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() require("snacks").picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() require("snacks").picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() require("snacks").picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() require("snacks").picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() require("snacks").picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() require("snacks").picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() require("snacks").picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() require("snacks").picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() require("snacks").picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() require("snacks").picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() require("snacks").picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() require("snacks").picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() require("snacks").picker.resume() end, desc = "Resume" },
      { "<leader>su", function() require("snacks").picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() require("snacks").picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() require("snacks").picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai", function() require("snacks").picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao", function() require("snacks").picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      { "<leader>ss", function() require("snacks").picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",  function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z",  function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>.",  function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>n",  function() require("snacks").notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete Buffer" },
      { "<leader>cR", function() require("snacks").rename.rename_file() end, desc = "Rename File" },
      { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
      { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<c-/>",      function() require("snacks").terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",      function() require("snacks").terminal() end, desc = "which_key_ignore" },
      { "]]",         function() require("snacks").words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },

    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
--   {  -- TODO: config telescope.nvim to better file seeker TUI
--   'nvim-telescope/telescope.nvim', version = '*',
--   event = "VeryLazy",
--   dependencies = {
--     'nvim-lua/plenary.nvim',
--     { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
--   }
-- },
})

local cmp = require('cmp') -- 3. 자동완성(cmp) 설정
cmp.setup({
  snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter로 완성 확정
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      else fallback() end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim-lsp' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- LSP 관련 편리한 단축키 설정
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    -- opts.desc = "go to declaration"
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- 선언으로 이동
    -- opts.desc = "go to definition"
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)    -- 정의로 이동
    opts.desc = "hover function info"
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)          -- 함수 정보 보기 (Hover)
    opts.desc = "rename"
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts) -- 변수/함수 이름 일괄 변경
    opts.desc = "code action"
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts) -- 코드 액션
    -- opts.desc = "find reference"
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)    -- 참조된 곳 찾기
    -- 🔍 에러/경고 확인 및 이동 단축키
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts) -- 커서 위치 에러 상세 보기
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts) -- 현재 파일의 전체 에러 목록 창 띄우기
  end,
})

vim.diagnostic.config({
  jump = { float = true },
  virtual_text = true,
  severity_sort = true,
})

-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('mini.icons').setup()

-- {  TODO: config noice.nvim to better TUI
--   "folke/noice.nvim",
--   event = "VeryLazy",
--   opts = {
  --     routes = {
    --       {
      --         filter = { event = "msg_show"},
      --       },
      --       opts = {
        --         stages = "static",
        --         timeout = 5000,
        --       },
        --     },
        --   },
        --   dependencies = {
          --     "MunifTanjim/nui.nvim",
          --   }
          -- },


