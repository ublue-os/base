ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install distrobox gnome-tweaks just vte291-gtk4-devel.x86_64 && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    ostree container commit

# Vanilla-first-setup
COPY --from=ghcr.io/adamisrael/vanilla-first-setup:latest /first-setup/vanilla-first-setup.tar.gz /tmp/vanilla-first-setup.tar.gz
RUN tar xf /tmp/vanilla-first-setup.tar.gz --strip-component=1 -C / && \
    chmod +x /usr/local/bin/vanilla-first-setup
