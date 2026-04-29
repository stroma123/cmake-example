# Build on top of gcc toolchain image
FROM registry.devabroadcast.com:4443/dev/db95_gcc:1.0

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install missing dev/debug tools
RUN apt-get update && apt-get install -y \
    cmake \
    ninja-build \
    gdb-multiarch \
    gdb \
    openssh-client \
    rsync \
    vim \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Ensure gdb is safe in container environments
RUN echo "set auto-load safe-path /" >> /etc/gdb/gdbinit