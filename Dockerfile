FROM ubuntu:22.04

ARG USER
ARG UID
ARG GID

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONIOENCODING=utf8 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

# Install basic tools and dependencies
RUN apt-get update && apt-get install -y \
    vim tmux nano htop autoconf automake build-essential \
    libtool cmake git sudo software-properties-common gperf \
    libselinux1-dev bison texinfo flex zlib1g-dev libexpat1-dev \
    libmpg123-dev wget curl python3-pip unzip pkg-config clang \
    llvm-dev apt-transport-https ca-certificates libc++-dev \
    zip tree re2c libglib2.0-dev gtk-doc-tools libtiff-dev \
    libpng-dev nasm tcl-dev libacl1-dev libgmp-dev libcap-dev \
    golang libarchive-dev ragel libfreetype6-dev libcairo2-dev \
    binutils-dev libgcrypt20-dev libdbus-glib-1-dev \
    libgirepository1.0-dev libgss-dev bzip2 libbz2-dev \
    libc-ares-dev libssh-dev libssl-dev libxml2-dev \
    libturbojpeg-dev liblzma-dev subversion dbus-cpp-dev \
    libunwind-dev protobuf-compiler cgroup-tools lcov \
    ninja-build

# Install LLVM 14
RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-14 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-14 main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 15CF4D18AF4F7421 && \
    apt update && \
    apt-get install -y clang-14 llvm-14-dev lld-14 clangd-14 lldb-14 libc++1-14 libc++-14-dev libc++abi-14-dev && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-14 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-14 100 && \
    update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-14 100 && \
    update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-14 100 && \
    update-alternatives --install /usr/bin/llvm-cov llvm-cov /usr/bin/llvm-cov-14 100

# Download LLVM source (if needed)
RUN mkdir /llvm && \
    cd /llvm && \
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/llvm-14.0.0.src.tar.xz -O llvm.tar.xz && tar xf llvm.tar.xz && \
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/compiler-rt-14.0.0.src.tar.xz -O compiler-rt.tar.xz && tar xf compiler-rt.tar.xz

# Copy fuzzer files (adjust paths as needed)
COPY --chown=$UID:$GID /path/to/fuzzer /fuzzer
COPY --chown=$UID:$GID /path/to/seeds /seeds
COPY --chown=$UID:$GID /path/to/autofz_bench /autofz_bench

# Set up Python 3
RUN apt install -y python3 python3-pip && \
    pip3 install --upgrade pip

# Set timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install additional tools
RUN apt-get install -y zsh locales direnv highlight jq && \
    locale-gen en_US.UTF-8

# Copy and install autofz
COPY init.sh /
COPY afl-cov/ /afl-cov
COPY autofz/ /autofz/autofz
COPY draw/ /autofz/draw
COPY setup.py /autofz/
COPY requirements.txt /autofz/

RUN pip3 install /autofz

ENV PATH="/autofz/autofz:/afl-cov:${PATH}"

# Add autofz user
RUN groupadd -g $GID -o $USER && \
    adduser --disabled-password --gecos '' -u $UID -gid $GID ${USER} && \
    adduser ${USER} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER

WORKDIR /home/$USER
