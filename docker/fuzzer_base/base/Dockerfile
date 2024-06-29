FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONIOENCODING=utf8 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8
RUN apt-get update && apt-get install -y \
    vim tmux nano htop autoconf automake build-essential \
    libtool cmake git sudo software-properties-common gperf \
    libselinux1-dev bison texinfo flex zlib1g-dev libexpat1-dev \
    libmpg123-dev wget curl python3-pip unzip pkg-config clang \
    llvm-dev apt-transport-https ca-certificates libc++-dev \
    zip tree re2c libtool \
    golang \
    libglib2.0-dev gtk-doc-tools libtiff-dev libpng-dev \
    nasm tcl-dev libacl1-dev libgmp-dev libcap-dev \
    libarchive-dev ragel libfreetype6-dev libcairo2-dev \
    binutils-dev libgcrypt20-dev libdbus-glib-1-dev \
    libgirepository1.0-dev libgss-dev bzip2 libbz2-dev \
    libc-ares-dev libssh-dev libssl-dev libxml2-dev \
    libturbojpeg0-dev liblzma-dev subversion \
    dbus-cpp-dev \
    make shtool \
    ninja-build cmake

# install proper tools
RUN apt-get update && \
    apt-get install -y vim tmux nano htop autoconf automake build-essential libtool cmake git sudo software-properties-common gperf libselinux1-dev  bison texinfo flex zlib1g-dev libexpat1-dev libmpg123-dev wget curl python3-pip python-pip unzip pkg-config clang llvm-dev apt-transport-https ca-certificates libc++-dev gcc-5-plugin-dev zip tree re2c bison libtool

RUN apt-get install -y git build-essential wget zlib1g-dev golang-go python-pip python-dev build-essential cmake

# lava
RUN apt install -y libglib2.0-dev gtk-doc-tools libtiff-dev libpng-dev \
  nasm tcl-dev libacl1-dev libgmp-dev libcap-dev

# fuzzer-test-suite
RUN apt install -y golang libarchive-dev libpng-dev ragel gtk-doc-tools libfreetype6-dev libglib2.0-dev libcairo2-dev \
  binutils-dev libgcrypt20-dev libdbus-glib-1-dev libgirepository1.0-dev libgss-dev bzip2 libbz2-dev libc-ares-dev libfreetype6-dev libglib2.0-dev \
  libssh-dev libssl-dev libxml2-dev libturbojpeg nasm liblzma-dev subversion

RUN apt-get install -y zip autoconf automake libtool bison re2c pkg-config flex bison dbus-cpp-dev


# New benchmark
## file
RUN apt install -y make autoconf automake libtool shtool

# Fuzzbench
RUN apt install -y ninja-build wget cmake

RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-14 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-14 main" >> /etc/apt/sources.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y clang-14 llvm-14-dev lld-14 clangd-14 lldb-14 libc++1-14 libc++-14-dev libc++abi-14-dev && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-14 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-14 100 && \
    update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-14 100 && \
    update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-14 100

# # RUN mkdir /llvm && \
# #   cd /llvm && \
# #   wget http://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz -O llvm.tar.xz && tar xf llvm.tar.xz && \
# #   wget http://releases.llvm.org/9.0.0/compiler-rt-9.0.0.src.tar.xz -O compiler-rt.tar.xz && tar xf compiler-rt.tar.xz

RUN mkdir /llvm && \
    cd /llvm && \
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/llvm-14.0.0.src.tar.xz -O llvm.tar.xz && tar xf llvm.tar.xz && \
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/compiler-rt-14.0.0.src.tar.xz -O compiler-rt.tar.xz && tar xf compiler-rt.tar.xz

RUN mkdir -p /fuzzer
