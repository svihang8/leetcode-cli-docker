# Build leetcode-cli (https://github.com/clearloop/leetcode-cli) without
# installing Rust/Cargo on the host.
FROM rust:bookworm AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libsqlite3-dev \
        libssl-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN cargo install leetcode-cli

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libsqlite3-0 \
        libssl3 \
        vim \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/cargo/bin/leetcode /usr/local/bin/leetcode

ENTRYPOINT ["leetcode"]
