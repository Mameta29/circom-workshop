#!/bin/bash
set -e

# Rustとcargo-binstallをインストール
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Node.jsと必要なnpmパッケージをインストール
npm install -g snarkjs

# circomをインストール
cargo install circom

# ptauファイルをダウンロード（必要な場合）
# mkdir -p ptau
# curl -L https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau -o ptau/powersOfTau28_hez_final_12.ptau

# justをインストール
cargo install just

# 必要なその他の依存関係をインストール
npm install

echo "セットアップが完了しました！"