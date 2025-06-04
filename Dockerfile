FROM gcc:13 AS builder

RUN apt-get update && apt-get install -y \
    wget \
    git \
    libssl-dev \
    libcurl4-openssl-dev \
    libwebsocketpp-dev \
    ninja-build

WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.31.3/cmake-3.31.3-linux-x86_64.sh && \
    chmod +x cmake-3.31.3-linux-x86_64.sh && \
    ./cmake-3.31.3-linux-x86_64.sh --skip-license --prefix=/usr/local

WORKDIR /app
COPY . .
RUN cmake -B build -S . -G Ninja && cmake --build build --config Release

# ⚠️ Use gcc:13 as runtime too (for full compatibility)
FROM gcc:13
WORKDIR /app
COPY --from=builder /app/build/messenger_server .
CMD ["./messenger_server"]
