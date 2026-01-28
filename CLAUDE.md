# dotfiles

sgotandのdotfilesリポジトリ。Dockerサンドボックス環境でのテスト・開発が可能。

## クイックスタート

```bash
make build   # イメージビルド
make shell   # 開発環境に入る
```

## コマンド一覧

| コマンド | 説明 |
|---------|------|
| `make build` | Dockerイメージをビルド |
| `make start` | バックグラウンドでコンテナ起動 |
| `make shell` | コンテナにアタッチ（未起動なら自動起動） |
| `make run` | 一時的に起動（終了後削除） |
| `make stop` | コンテナ停止 |
| `make clean` | コンテナとボリュームを削除 |
| `make status` | ステータス表示 |
| `make list` | 全dotfilesコンテナ一覧 |

## git worktreeでの開発

```bash
git worktree add ../dotfiles-feature feature/xyz
cd ../dotfiles-feature
make build && make shell
# → 独立したコンテナ・ボリュームで起動
```

## ディレクトリ構成

```
docker/
├── Dockerfile           # Rocky Linux 9 + neovim/tmux/zsh/node
├── docker-compose.yml   # worktree対応の動的設定
└── scripts/
    ├── dotfiles-dev     # 管理スクリプト
    └── entrypoint.sh    # シンボリックリンク自動設定
```

## 含まれるツール

- Neovim (stable)
- tmux 3.5
- zsh
- Node.js (最新LTS)
- Python3 + pynvim

## Claude Code スキル

| スキル | 説明 |
|--------|------|
| `/tmux-improve` | tmux設定の改善ワークフロー |

### /tmux-improve

tmux改善のブレインストーミング・実装・ドキュメント更新を行う。

```bash
# 新しいアイデアを追加
/tmux-improve idea

# アイデア番号を指定して実装
/tmux-improve implement 5

# 実装状況を確認
/tmux-improve status
```

関連ファイル:
- `docs/tmux-improvements.md` - 改善アイデア一覧 (23項目)
- `docs/tmux-usage.md` - 操作方法ドキュメント
