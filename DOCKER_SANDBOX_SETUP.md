# dotfiles Docker サンドボックス環境 セットアップ記録

## 概要

dotfilesリポジトリ（git@github.com:sgotand/.dotfiles.git）に対して、Dockerを使ったサンドボックス開発環境を構築しました。

## 要件

ユーザーからの要求:
1. **目的**: dotfiles自体の開発・テスト
2. **git worktree対応**: 各worktreeディレクトリごとに独立したDockerコンテナを起動
3. **ホームディレクトリ永続化**: worktreeごとに分離されたDockerボリュームで永続化
4. **リアルタイム反映**: dotfilesの変更がコンテナ内ですぐに反映される

## 作成したファイル

### 1. docker/Dockerfile

Rocky Linux 9ベースのDockerイメージ:
- neovim (stable)
- tmux 3.5
- zsh
- Node.js (n経由で最新版)
- Python3 + pynvim

ビルド時の修正点:
- `curl-minimal`との競合を解決するため `--allowerasing` オプションを追加
- NeovimのダウンロードURLを `nvim-linux64.tar.gz` → `nvim-linux-x86_64.tar.gz` に変更
- `chsh`コマンドがないため、`useradd -s /usr/bin/zsh` でシェルを設定

### 2. docker/docker-compose.yml

環境変数による動的設定:
- `WORKTREE_NAME`: worktree名（コンテナ名・ボリューム名に使用）
- `DOTFILES_PATH`: dotfilesのパス
- `USERNAME`, `USER_UID`, `USER_GID`: ユーザー情報

ボリューム構成:
- dotfiles: read-onlyでバインドマウント
- ホームディレクトリ: 名前付きボリュームで永続化

### 3. docker/scripts/dotfiles-dev

メイン管理スクリプト。以下のコマンドを提供:

| コマンド | 説明 |
|---------|------|
| `build` | 現在のworktree用イメージをビルド |
| `start` | バックグラウンドでコンテナ起動 |
| `shell` | コンテナにアタッチ（未起動なら起動） |
| `run` | 一時的に起動して接続、終了後削除 |
| `stop` | コンテナ停止 |
| `clean` | コンテナとボリュームを削除 |
| `status` | 現在のworktreeのステータス表示 |
| `list` | 全dotfilesコンテナ一覧 |
| `clean-all` | 全コンテナ・ボリューム削除 |

### 4. docker/scripts/entrypoint.sh

コンテナ起動時の初期化:
- `~/.config/nvim/init.lua` → dotfilesへのシンボリックリンク
- `~/.tmux.conf` → dotfilesへのシンボリックリンク
- `~/.zshrc`, `~/.zshenv` の生成
- tmuxプラグインマネージャ(tpm)のクローン

### 5. Makefile

`dotfiles-dev`スクリプトへのシンプルなラッパー

## 削除したファイル

- `Dockerfile` (ルート) - docker/Dockerfileに移動
- `build` - Makefileに統合
- `run` - Makefileに統合

## 動作確認結果

```
$ make build
Built image: dotfiles:dotfiles-inspect

$ make start
Started container: dotfiles-dotfiles-inspect

$ docker exec dotfiles-dotfiles-inspect nvim --version
NVIM v0.11.5

$ docker exec dotfiles-dotfiles-inspect tmux -V
tmux 3.5

$ make status
=== Worktree: dotfiles-inspect ===

Containers:
NAMES                       STATUS          IMAGE
dotfiles-dotfiles-inspect   Up 26 seconds   dotfiles:dotfiles-inspect

Volumes:
VOLUME NAME                      DRIVER
dotfiles-dotfiles-inspect-home   local
```

シンボリックリンクも正しく設定:
```
~/.config/nvim/init.lua -> ~/.dotfiles/init.lua
~/.tmux.conf -> ~/.dotfiles/tmux.conf
```

## 使い方

### 基本操作

```bash
# イメージビルド
make build

# バックグラウンドで起動
make start

# シェルに入る
make shell

# 停止
make stop

# クリーンアップ
make clean
```

### git worktreeでの開発

```bash
# 新しいworktreeを作成
git worktree add ../dotfiles-feature-xyz feature/xyz
cd ../dotfiles-feature-xyz

# そのworktree用の環境を構築
make build
make shell
# → 独立したコンテナ・ボリュームで起動
```

## 命名規則

| 項目 | 形式 | 例 |
|------|------|-----|
| コンテナ名 | `dotfiles-<worktree名>` | `dotfiles-main` |
| ボリューム | `dotfiles-<worktree名>-home` | `dotfiles-main-home` |
| イメージ | `dotfiles:<worktree名>` | `dotfiles:main` |

## 日付

2026-01-16
