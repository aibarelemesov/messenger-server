# Stage 1: Build environment
FROM gcc:13 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    libssl-dev \
    libcurl4-openssl-dev \
    libwebsocketpp-dev \
    ninja-build && \
    rm -rf /var/lib/apt/lists/*

# Install CMake 3.31.3
RUN apt-get update && apt-get install -y cmake ninja-build

# Prepare and build your project
WORKDIR /app
COPY . .
RUN cmake -B build -S . -G Ninja && \
    cmake --build build --config Release

# Stage 2: Runtime environment
FROM gcc:13

WORKDIR /app
COPY --from=builder /app/build/messenger_server .

RUN chmod +x messenger_server

CMD ["./messenger_server"]