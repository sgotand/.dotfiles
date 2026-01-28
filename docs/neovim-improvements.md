# Neovim 改善案

今後実装を検討している Neovim 設定の改善案。

---

## 1. LSP設定の統合管理 (mason.nvim)

**優先度**: 高

LSPサーバー、フォーマッター、リンターを一元管理。

### 推奨プラグイン

```lua
-- lazy.nvim
{
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "ts_ls", "pyright", "rust_analyzer" },
      automatic_installation = true,
    })
  end,
}
```

### キーマップ例

```lua
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
```

**効果**:
- LSPサーバーの自動インストール・更新
- 言語ごとの設定を統一管理
- `:Mason` でGUI管理

---

## 2. 自動補完システム (nvim-cmp)

**優先度**: 高

高速で拡張性の高い補完エンジン。

### 基本設定

```lua
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })
  end,
}
```

**効果**:
- LSP、スニペット、バッファ、パスからの補完
- Tab/Shift-Tabでナビゲーション
- 高速なファジーマッチング

---

## 3. ファジーファインダー (telescope.nvim)

**優先度**: 高

ファイル、grep、バッファなど何でも検索。

### 基本設定

```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    })
    telescope.load_extension('fzf')
  end,
}
```

### キーマップ

```lua
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Commands' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Symbols' })
```

**効果**:
- 統一されたUIで何でも検索
- プレビュー付き
- fzf-nativeで高速化

---

## 4. ファイルエクスプローラー (neo-tree.nvim)

**優先度**: 中

モダンなファイルツリー。

### 基本設定

```lua
{
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<cr>"] = "open",
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
        },
      },
    })
  end,
}
```

### キーマップ

```lua
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle explorer' })
vim.keymap.set('n', '<leader>o', ':Neotree focus<CR>', { desc = 'Focus explorer' })
```

**効果**:
- Git状態の表示
- フローティングウィンドウ対応
- バッファ、Git状態も表示可能

---

## 5. Git統合 (gitsigns + lazygit)

**優先度**: 高

行単位のGit情報表示とlazygit連携。

### gitsigns設定

```lua
{
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup({
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr }

        vim.keymap.set('n', ']c', gs.next_hunk, opts)
        vim.keymap.set('n', '[c', gs.prev_hunk, opts)
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, opts)
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, opts)
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts)
        vim.keymap.set('n', '<leader>hb', gs.blame_line, opts)
      end
    })
  end,
}
```

### lazygit連携

```lua
vim.keymap.set('n', '<leader>gg', function()
  vim.cmd('terminal lazygit')
  vim.cmd('startinsert')
end, { desc = 'Open lazygit' })
```

**効果**:
- 変更行をサイン列に表示
- hunk単位でstage/reset
- インラインblame

---

## 6. ステータスライン (lualine.nvim)

**優先度**: 中

高速で美しいステータスライン。

### 基本設定

```lua
{
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    })
  end,
}
```

**効果**:
- LSP診断情報の表示
- Git情報 (branch, diff)
- モード別の色分け

---

## 7. バッファライン (bufferline.nvim)

**優先度**: 中

タブのようなバッファ表示。

### 基本設定

```lua
{
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        offsets = {
          { filetype = "neo-tree", text = "File Explorer", highlight = "Directory" },
        },
      },
    })
  end,
}
```

### キーマップ

```lua
vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { desc = 'Pick buffer' })
vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', { desc = 'Pick close' })
```

**効果**:
- バッファをタブ風に表示
- LSP診断アイコン
- ピック機能で素早く選択

---

## 8. シンタックスハイライト強化 (treesitter)

**優先度**: 高

ASTベースの正確なハイライト。

### 基本設定

```lua
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "tsx",
        "python", "rust", "go",
        "html", "css", "json", "yaml", "toml",
        "bash", "markdown", "markdown_inline",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
```

### 追加モジュール

```lua
{
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          goto_next_start = { ["]m"] = "@function.outer" },
          goto_previous_start = { ["[m"] = "@function.outer" },
        },
      },
    })
  end,
}
```

**効果**:
- 正確なシンタックスハイライト
- 関数/クラス単位のテキストオブジェクト
- インクリメンタル選択

---

## 9. コメントトグル (Comment.nvim)

**優先度**: 中

言語に応じた賢いコメント。

### 基本設定

```lua
{
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      -- gcc: 行コメント, gbc: ブロックコメント
      -- gc{motion}: モーションでコメント
    })
  end,
}
```

### ts-context-commentstring連携

```lua
{
  "JoosepAlviste/nvim-ts-context-commentstring",
  config = function()
    require('ts_context_commentstring').setup({
      enable_autocmd = false,
    })

    require("Comment").setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end,
}
```

**効果**:
- `gcc` で行コメントトグル
- `gc{motion}` でまとめてコメント
- JSX/TSX内でも正しいコメント形式

---

## 10. サラウンド操作 (nvim-surround)

**優先度**: 中

括弧やクォートの追加・変更・削除。

### 基本設定

```lua
{
  "kylechui/nvim-surround",
  config = function()
    require("nvim-surround").setup({})
  end,
}
```

### 操作例

| 操作 | コマンド | Before | After |
|------|----------|--------|-------|
| 追加 | `ysiw"` | hello | "hello" |
| 変更 | `cs"'` | "hello" | 'hello' |
| 削除 | `ds"` | "hello" | hello |
| 追加(行) | `yss)` | hello world | (hello world) |
| ビジュアル | `S"` | [selected] | "[selected]" |

**効果**:
- vim-surroundのLua版
- dot repeatサポート
- カスタムサラウンド定義可能

---

## 11. 高速モーション (flash.nvim)

**優先度**: 中

画面内の任意の位置に素早くジャンプ。

### 基本設定

```lua
{
  "folke/flash.nvim",
  config = function()
    require("flash").setup({
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        multi_window = true,
      },
      modes = {
        char = {
          enabled = true,
          jump_labels = true,
        },
      },
    })
  end,
}
```

### キーマップ

```lua
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
```

**効果**:
- `s{char}{char}` で2文字検索→ラベルジャンプ
- `S` でtreesitterノード選択
- f/t の強化版としても使用可能

---

## 12. ターミナル統合 (toggleterm.nvim)

**優先度**: 中

Neovim内でターミナルを便利に使用。

### 基本設定

```lua
{
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = {
        border = "curved",
        width = function() return math.floor(vim.o.columns * 0.8) end,
        height = function() return math.floor(vim.o.lines * 0.8) end,
      },
    })
  end,
}
```

### カスタムターミナル

```lua
local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true,
})

vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit" })
```

**効果**:
- `<C-\>` でターミナルトグル
- フローティング/水平/垂直
- 複数ターミナル管理

---

## 13. セッション管理 (persistence.nvim)

**優先度**: 低

ワークスペースの状態を保存・復元。

### 基本設定

```lua
{
  "folke/persistence.nvim",
  event = "BufReadPre",
  config = function()
    require("persistence").setup({
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize" },
    })
  end,
}
```

### キーマップ

```lua
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't save session" })
```

**効果**:
- ディレクトリごとにセッション自動保存
- 最後のセッションを復元
- バッファ、ウィンドウレイアウト保持

---

## 14. デバッガー統合 (nvim-dap)

**優先度**: 低

Neovim内でデバッグ。

### 基本設定

```lua
{
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
  end,
}
```

### キーマップ

```lua
vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "Debug: Continue" })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
```

**効果**:
- ブレークポイント設定
- ステップ実行
- 変数ウォッチ

---

## 15. AIコード補完 (copilot.lua)

**優先度**: 中

GitHub Copilotとの統合。

### 基本設定

```lua
{
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-w>",
          accept_line = "<M-e>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
      },
    })
  end,
}
```

### nvim-cmp統合

```lua
{
  "zbirenbaum/copilot-cmp",
  dependencies = "copilot.lua",
  config = function()
    require("copilot_cmp").setup()
  end,
}
```

**効果**:
- インライン補完候補
- `Alt+l` で候補を受け入れ
- nvim-cmpと統合可能

---

## 16. which-key.nvim (キーマップヘルプ)

**優先度**: 高

キーを押した後に続くキーマップを表示。

### 基本設定

```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      plugins = {
        spelling = { enabled = true },
      },
      win = {
        border = "rounded",
      },
    })

    -- グループ登録
    wk.add({
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>b", group = "Buffer" },
      { "<leader>l", group = "LSP" },
      { "<leader>x", group = "Diagnostics" },
    })
  end,
}
```

**効果**:
- leaderキー後に使えるキーを表示
- キーマップを覚えなくても操作可能
- グループ化で整理

---

## 17. インデントガイド (indent-blankline.nvim)

**優先度**: 中

インデントレベルを視覚的に表示。

### 基本設定

```lua
{
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function()
    require("ibl").setup({
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = { "help", "dashboard", "neo-tree", "Trouble" },
      },
    })
  end,
}
```

**効果**:
- インデントレベルが一目でわかる
- 現在のスコープをハイライト
- Pythonなどインデント重要な言語で特に有用

---

## 18. 自動ペア入力 (nvim-autopairs)

**優先度**: 中

括弧やクォートの自動ペア入力。

### 基本設定

```lua
{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local autopairs = require("nvim-autopairs")
    autopairs.setup({
      check_ts = true,  -- treesitter連携
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
      fast_wrap = {
        map = "<M-e>",  -- Alt+e で wrap
      },
    })

    -- nvim-cmp連携
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
```

**効果**:
- `(` 入力で自動的に `)` が追加
- treesitter連携で文脈に応じた動作
- `Alt+e` で既存テキストをwrap

---

## 19. 診断表示強化 (trouble.nvim)

**優先度**: 中

LSP診断をリスト表示。

### 基本設定

```lua
{
  "folke/trouble.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("trouble").setup({
      auto_close = true,
      use_diagnostic_signs = true,
    })
  end,
}
```

### キーマップ

```lua
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })
```

**効果**:
- エラー/警告を一覧表示
- ファイル横断で問題箇所を把握
- quickfixより見やすいUI

---

## 20. カラースキーム (catppuccin/tokyonight)

**優先度**: 中

モダンで目に優しいカラースキーム。

### catppuccin

```lua
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",  -- latte, frappe, macchiato, mocha
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
```

### tokyonight

```lua
{
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",  -- storm, moon, night, day
      transparent = false,
      terminal_colors = true,
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
```

**効果**:
- 長時間作業でも目が疲れにくい
- プラグインとの統合が完璧
- 豊富なバリエーション

---

## 21. 通知UI (nvim-notify / noice.nvim)

**優先度**: 低

通知やコマンドラインをモダンに。

### nvim-notify

```lua
{
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({
      stages = "fade_in_slide_out",
      timeout = 3000,
      render = "compact",
    })
    vim.notify = notify
  end,
}
```

### noice.nvim (包括的UI)

```lua
{
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    })
  end,
}
```

**効果**:
- 通知がポップアップで表示
- コマンドラインが中央に表示
- LSPの進捗表示

---

## 22. マークダウンプレビュー

**優先度**: 低

マークダウンをリアルタイムでプレビュー。

### markdown-preview.nvim

```lua
{
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_theme = "dark"
  end,
  ft = { "markdown" },
}
```

### render-markdown.nvim (インラインプレビュー)

```lua
{
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  config = function()
    require("render-markdown").setup({})
  end,
}
```

**効果**:
- ブラウザでリアルタイムプレビュー
- または Neovim内でレンダリング
- 数式、Mermaid図対応

---

## 23. Git差分表示 (diffview.nvim)

**優先度**: 中

ファイル差分を見やすく表示。

### 基本設定

```lua
{
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require("diffview").setup({
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    })
  end,
}
```

### キーマップ

```lua
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff view" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Branch history" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close diff" })
```

**効果**:
- 複数ファイルの差分を一度に表示
- ファイル履歴の閲覧
- マージコンフリクト解決支援

---

## 24. プロジェクト管理 (project.nvim)

**優先度**: 低

プロジェクトの自動検出と切り替え。

### 基本設定

```lua
{
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git", "Makefile", "package.json", "Cargo.toml" },
      show_hidden = false,
      silent_chdir = true,
    })

    -- telescope連携
    require("telescope").load_extension("projects")
  end,
}
```

### キーマップ

```lua
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Projects" })
```

**効果**:
- プロジェクトルートを自動検出
- telescopeでプロジェクト切り替え
- 最近のプロジェクト履歴

---

## 25. テスト実行 (neotest)

**優先度**: 中

Neovim内でテストを実行・表示。

### 基本設定

```lua
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- 言語別アダプター
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-python",
    "rouge8/neotest-rust",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({
          jestCommand = "npm test --",
        }),
        require("neotest-python")({
          runner = "pytest",
        }),
        require("neotest-rust"),
      },
    })
  end,
}
```

### キーマップ

```lua
vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Test summary" })
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open() end, { desc = "Test output" })
```

**効果**:
- カーソル位置のテストを実行
- テスト結果をサイドパネルに表示
- 複数言語対応

---

## 実装優先度まとめ

| 優先度 | # | 改善項目 | 理由 |
|--------|---|---------|------|
| 高 | 1 | LSP統合管理 (mason) | 開発の基盤 |
| 高 | 2 | 自動補完 (nvim-cmp) | 生産性向上 |
| 高 | 3 | ファジーファインダー (telescope) | ナビゲーション |
| 高 | 5 | Git統合 (gitsigns) | バージョン管理 |
| 高 | 8 | Treesitter | 正確なハイライト |
| 中 | 4 | ファイルエクスプローラー | ファイル操作 |
| 中 | 6 | ステータスライン | 情報表示 |
| 中 | 7 | バッファライン | バッファ管理 |
| 中 | 9 | コメントトグル | 編集効率 |
| 中 | 10 | サラウンド操作 | 編集効率 |
| 中 | 11 | 高速モーション | 移動効率 |
| 中 | 12 | ターミナル統合 | ワークフロー |
| 中 | 15 | AIコード補完 | 生産性向上 |
| 低 | 13 | セッション管理 | 便利機能 |
| 低 | 14 | デバッガー統合 | 必要時のみ |
| 高 | 16 | which-key.nvim | キー発見性 |
| 中 | 17 | インデントガイド | コード視認性 |
| 中 | 18 | 自動ペア入力 | 編集効率 |
| 中 | 19 | 診断表示強化 (trouble) | エラー把握 |
| 中 | 20 | カラースキーム | 視認性・疲労軽減 |
| 中 | 23 | Git差分表示 (diffview) | 差分確認 |
| 中 | 25 | テスト実行 (neotest) | TDD効率化 |
| 低 | 21 | 通知UI (noice) | UI改善 |
| 低 | 22 | マークダウンプレビュー | ドキュメント作業 |
| 低 | 24 | プロジェクト管理 | プロジェクト切替 |
