FROM ubuntu:22.04 AS base

LABEL maintainer="ImmortalWrt Builder"

# Install required dependencies
COPY devenv/dependencies.sh /install_dependencies
RUN chmod +x /install_dependencies && \
    /install_dependencies && \
    rm -rf /install_dependencies

# Create a non-root user with sudo access (no password required)
RUN useradd -m -u 1000 -G sudo builder && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER builder
WORKDIR /home/builder

FROM base AS immortalwrt

ARG IMMORTALWRT_VERSION=master

# Clone ImmortalWrt repository
RUN git clone https://github.com/immortalwrt/immortalwrt immortalwrt && \
    git -C immortalwrt checkout ${IMMORTALWRT_VERSION}

# Apply mac80211 patches (wcn36xx/ath10k-sdio support)
COPY --chmod=755 apply_patches.sh ./
RUN ./apply_patches.sh immortalwrt

# Update and install feeds
RUN cd immortalwrt && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a && \
    rm -rf tmp

# Fix LuCI getFeatures crash when odhcpd is present (conditional - may be fixed in release)
RUN LUCI_FILE="immortalwrt/feeds/luci/modules/luci-base/root/usr/share/rpcd/ucode/luci" && \
    if [ -f "$LUCI_FILE" ] && grep -q 'result\.odhcpd = false;' "$LUCI_FILE"; then \
      sed -i 's/result\.odhcpd = false;/result.odhcpd = {};/' "$LUCI_FILE"; \
    fi

WORKDIR /home/builder/immortalwrt

CMD ["/bin/bash"]
