# Use an official Rust image
FROM rust:1.74-slim as builder

# Create app directory
WORKDIR /usr/src/app

# Cache dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release

# Copy full source and build
COPY . .
RUN cargo build --release

# Runtime container
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/app/target/release/flipkart_scraper_api /usr/local/bin/flipkart_scraper_api

ENV RUST_LOG=info
EXPOSE 3000

CMD ["flipkart-scraper-api"]
