# Circom ワークショップ

このリポジトリは、Circomを使ったゼロ知識証明（ZKP）の基本を実践的に学ぶためのワークショップ資料です。実際に手を動かしながらCircomの動作を理解し、ZKPの基礎が学べるようになっています。

> **注意**: こちらのワークショップは[oskarth/zkintro-tutorial](https://github.com/oskarth/zkintro-tutorial)を参考に作成されています。

## 開始方法

## 1. GitHub Code Spaceで開く（推奨）

最も簡単な方法は、GitHub Code Spaceを使用することです：

1. リポジトリページの「Code」ボタンをクリック
2. 「Codespaces」タブを選択
3. 「Create codespace on main」をクリック

ブラウザ上で開発環境が立ち上がり、必要なツールが全てインストールされた状態で開始できます。

## 使用コマンド
### 回路のビルド

```bash
just build example1
```

### Trusted Setup（フェーズ1と2）

```bash
just trusted_setup example1
```

### Trusted Setup（フェーズ2のみ）

```bash
just trusted_setup_phase2 example2
```

### 証明の生成

```bash
just generate_proof example1
```

### 証明の検証

```bash
just verify_proof example1
```

## 2. ローカル環境で実行する場合

Code Spaceでうまく動作しない場合や、ローカル環境で実行したい場合は、以下の手順で設定できます：

```bash
# リポジトリをクローン
git clone https://github.com/Mameta29/circom-workshop.git
cd circom-workshop

# 依存関係のインストール（just, rust, circom, snarkjs）
./scripts/prepare.sh
```

## 依存関係の説明

このワークショップでは以下の主要な依存関係を使用します：

### just

[just](https://github.com/casey/just)は、コマンドランナーツールで、Makefileに似た`justfile`でタスクを定義し実行できます。複雑なコマンドを簡単に実行するためのショートカットを提供します。

```bash
# justのインストール（prepare.shに含まれています）
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
```

### circom

[circom](https://github.com/iden3/circom)は、ZKPの算術回路をコンパイルするためのDSL（ドメイン特化言語）で、R1CSフォーマットの制約システムとWitness計算のためのWebAssemblyコードを生成します。

```bash
# circomのインストール（prepare.shに含まれています）
cargo install circom
```

### snarkjs

[snarkjs](https://github.com/iden3/snarkjs)は、zkSNARKプルーフをJavaScriptで実装したピュアライブラリです。Groth16などの証明システムをサポートしています。

```bash
# snarkjsのインストール（prepare.shに含まれています）
npm install -g snarkjs
```

## ディレクトリ構造

### @example1, @example2, @example3, @example4

サンプル回路が含まれるディレクトリです。各ディレクトリには：
- `.circom`ファイル: Circomで記述された回路定義
- `input.json`: 証明生成に使用される入力値
- `target/`: ビルドプロセスで生成されるファイルの保存先

### @scripts

各種スクリプトが保存されたディレクトリです。justfileから呼び出される実行スクリプトが含まれています。

- `prepare.sh`: 依存関係（just, rust, circom, snarkjs）のインストール
- `build.sh`: Circom回路をコンパイルしてR1CSとWASMを生成
- `trusted_setup.sh`: 信頼された設定フェーズ1と2を実行
- `trusted_setup_phase1.sh`: Powers of Tauセレモニーの第1フェーズ
- `trusted_setup_phase2.sh`: 特定の回路に対する第2フェーズ
- `generate_proof.sh`: zkSNARK証明の生成
- `verify_proof.sh`: 生成された証明の検証
- `generate_identity.sh`: アイデンティティの秘密鍵と公開コミットメントの生成
- `install_just.sh`: justコマンドランナーのインストール

### @ptau

信頼された設定（Trusted Setup）のPhase 1で使用される「Powers of Tau」セレモニーのファイルを格納するディレクトリです。

- `pot12.ptau`: あらかじめ生成されたPhase 1の出力ファイル（最大2^12の制約をサポート）

### @utils

ウィットネス計算などの補助スクリプトを含むユーティリティディレクトリです。

- `generate_witness.js`: 回路の入力からウィットネスを生成するスクリプト
- `witness_calculator.js`: WASMモジュールを使用してウィットネス計算を行うユーティリティ

## @justfile コマンド解説

`justfile`は、複雑なコマンドをシンプルなショートカットとして定義するファイルです。

### prepare

```bash
just prepare
```

開発環境をセットアップし、必要な依存関係（just, rust, circom, snarkjs）をインストールします。

### build

```bash
just build example1
```

指定した回路（例：example1.circom）をコンパイルします。出力として制約システム（.r1cs）とウィットネス計算用のWebAssemblyファイル（.wasm）が生成されます。

### trusted_setup

```bash
just trusted_setup example1
```

zkSNARKの信頼された設定を実行します。フェーズ1（汎用的なセットアップ）とフェーズ2（回路特有のセットアップ）の両方を行い、証明鍵（proving key）と検証鍵（verification key）を生成します。

### trusted_setup_phase2

```bash
just trusted_setup_phase2 example1
```

既存のPhase 1の出力（ptau/pot12.ptau）を使用して、Phase 2のみを実行します。特定の回路に対する証明鍵と検証鍵を生成します。

### generate_proof

```bash
just generate_proof example1
```

入力値（input.json）を使用して、zkSNARK証明を生成します。出力として証明（proof.json）と公開出力（public.json）が生成されます。

### verify_proof

```bash
just verify_proof example1
```

生成された証明が有効かどうかを検証します。検証結果はtrueまたはfalseで表示されます。

### generate_identity

```bash
just generate_identity
```

アイデンティティの秘密鍵（identity_secret）と公開コミットメント（identity_commitment）のペアを生成します。

### all

```bash
just all example1
```

指定した例（example1など）に対して、準備、ビルド、信頼された設定、証明生成、検証の全ステップを順番に実行します。

## ZKPワークフロー解説

1. **回路設計**: Circom言語で算術回路を設計（`.circom`ファイル）
2. **回路コンパイル**: 回路をR1CS制約システムと計算用WASMにコンパイル
3. **信頼された設定**: 
   - Phase 1: 汎用的なPowers of Tau（複数の回路で再利用可能）
   - Phase 2: 特定の回路に対する証明鍵と検証鍵の生成
4. **ウィットネス計算**: 入力値からウィットネス（制約を満たす値の割り当て）を計算
5. **証明生成**: 証明鍵とウィットネスを使用して証明を生成
6. **証明検証**: 検証鍵、公開入力、証明を使用して証明の有効性を検証

## 使用方法

以下のコマンドで各サンプルを実行できます。`example`は`example1`や`example2`などのサンプルディレクトリ名に置き換えてください。

**注意**: 現在のCircomの回路は未完成です。動作させるには回路を完成させる必要があります。行き詰まった場合は、`*-solution.circom`という名前のファイルを参照してください。

### 回路のビルド

```bash
just build example1
```

### 信頼された準備（フェーズ1と2）

```bash
just trusted_setup example1
```

### 証明の生成

```bash
just generate_proof example1
```

### 証明の検証

```bash
just verify_proof example1
```

## その他のコマンド

信頼された準備のフェーズ2のみを実行する場合：

```bash
just trusted_setup_phase2 example2
```

ID鍵ペア（identity_secretとidentity_commitment）の生成：

```bash
just generate_identity
```

## トラブルシューティング

### Code Spaceでのエラー

Code Spaceで「exec format error」などのエラーが発生した場合：

1. リポジトリをフォークする
2. ローカルでマルチアーキテクチャイメージをビルド：
   ```bash
   docker buildx create --name mybuilder --use
   docker buildx inspect --bootstrap
   docker buildx build --platform linux/amd64,linux/arm64 -t [あなたのユーザー名]/circom-workshop:latest --push .
   ```
3. `.devcontainer/devcontainer.json`のimageパスを変更
4. 変更をプッシュし、再度Code Spaceを開く

### ローカル環境での問題

ローカル実行時に問題が発生した場合は、以下を確認してください：

- 最新バージョンのRust、Node.jsがインストールされていること
- `prepare.sh`スクリプトが正常に実行されたこと
- M1/M2 Macの場合、Rosettaを使用してx86_64バイナリを実行している可能性があります

## 学習リソース

- [zkintro.com](https://zkintro.com/articles/programming-zkps-from-zero-to-hero) - ゼロ知識証明のプログラミング入門
- [Circom公式ドキュメント](https://docs.circom.io/)
- [SnarkJS GitHub](https://github.com/iden3/snarkjs)

## 謝辞

このワークショップは[oskarth/zkintro-tutorial](https://github.com/oskarth/zkintro-tutorial)の内容を参考に作成されています。オリジナルの素晴らしい教材を提供してくださった作者に感謝します。
