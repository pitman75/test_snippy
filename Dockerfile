FROM debian:stable

# Update Debian to latest
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git \
        build-essential \
        cmake \
        clang \
        ccache \
        ninja-build \
        lld \
        python3 \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/syntacore/snippy.git
COPY ./release.cmake /app/snippy/
WORKDIR /app/snippy

RUN cmake -S llvm -B release/build -G Ninja -C release.cmake
RUN cmake --build release/build
RUN cmake --install release/build
# RUN cmake --build release/build/ --target check-llvm-tools-llvm-snippy


