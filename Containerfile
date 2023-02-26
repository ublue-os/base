# Multi-stage build
ARG FEDORA_MAJOR_VERSION=37

## Build ublue-os-base
FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

# Add Vanilla First Setup
RUN wget https://copr.fedorainfracloud.org/coprs/ublue-os/vanilla-first-setup/repo/fedora-$(rpm -E %fedora)/ublue-os-vanilla-first-setup-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ublue-os-vanilla-first-setup.repo

COPY etc /etc
COPY usr /usr

COPY ublue-firstboot /usr/bin

COPY recipe.yml /etc/ublue-recipe.yml

# https://github.com/TomWright/dasel is a single-binary program used for reading the recipe.yml.
# It is not available as an rpm.
RUN curl -sSLf "$(curl -sSLf https://api.github.com/repos/tomwright/dasel/releases/latest | grep browser_download_url | grep linux_amd64 | grep -v .gz | cut -d\" -f 4)" -L -o /usr/bin/dasel && \
    chmod +x /usr/bin/dasel

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install vte291-gtk4-devel vanilla-first-setup && \
    
    echo "-- Installing RPMs defined in recipe.yml --" && \
    rpm_packages=$(dasel -f /etc/ublue-recipe.yml -r yaml -w json -s 'rpm_packages') && \
    rpm_packages_count=$(echo $rpm_packages | dasel -r json -s 'len()') && \
    for i in $( seq 0 $(($rpm_packages_count-1)) ); do \
        pkg=$(echo $rpm_packages | dasel -r json "[${i}]" | tr -d '"') && \
        echo "Installing: ${pkg}" && \
        rpm-ostree install $pkg; \
    done && \ 
    echo "---" && \

    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-system-update.timer && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-vanilla-first-setup.repo && \
    rm -rf \
        /tmp/* \
        /var/* && \
    ostree container commit
