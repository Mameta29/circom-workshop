FROM ubuntu:22.04

# タイムゾーンの設定（インタラクティブプロンプトを避けるため）
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# 基本的なツールのインストール
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    nodejs \
    npm \
    python3 \
    wget \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Rustのインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# justのインストール
RUN curl --proto '=https' -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Circomのインストール
RUN git clone https://github.com/iden3/circom.git && \
    cd circom && \
    cargo build --release && \
    cargo install --path circom && \
    cd .. && \
    rm -rf circom

# snarkJSのインストール
RUN npm install -g snarkjs

# PTAUファイルのダウンロード
RUN mkdir -p /ptau && \
    curl -L https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau -o /ptau/powersOfTau28_hez_final_12.ptau

# ワークディレクトリの設定
WORKDIR /workspace

# 必要なスクリプトやファイルのコピー
COPY scripts /workspace/scripts
COPY example1 /workspace/example1
COPY example2 /workspace/example2
COPY example3 /workspace/example3
COPY example4 /workspace/example4
COPY justfile /workspace/justfile
COPY README.md /workspace/README.md

# 実行権限の付与
RUN chmod +x /workspace/scripts/*.sh

# パスの設定
RUN ln -s /ptau /workspace/ptau

CMD ["/bin/bash"]