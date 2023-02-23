# CultOS

[![build-ublue](https://github.com/iamcult/cultos/actions/workflows/build.yml/badge.svg)](https://github.com/iamcult/cultos/actions/workflows/build.yml)

A base image with a (mostly) stock Fedora Silverblue. Help us make a sweet base image: Pull requests and improvements appreciated and encouraged! Scroll to the bottom to see how to make your own!

## What is this?

This is a base Fedora Silverblue image designed to be customized to whatever you want, have GitHub build it for you, and then host it for you. You then just tell your computer to boot off of that image. GitHub keeps 90 days worth image backups for you, thanks Microsoft! 

Check out the [spec for Fedora](https://fedoraproject.org/wiki/Changes/OstreeNativeContainerStable) for more information and proper explanation.

## Usage

Warning: This is an experimental feature and should not be used in production (yet), however it's pretty close) Depending on the version of rpm-ostree on your system you might need to pass an additional `--experimental` flag

To rebase an existing Silverblue/Kinoite machine to the latest release (37): 

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/iamcult/cultos:37
    
We build date tags as well, so if you want to rebase to a particular day's release:
  
    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/iamcult/cultos:20230223

The `latest` tag will automatically point to the latest build. Note that when a new version of Fedora is released that the `latest` tag will get updated to that latest release automatically. 

## Features

- Start with a base Fedora Silverblue 37 image
- Removes Firefox from the base image
- Adds distrobox to the base image
- Sets automatic staging of updates for the system
- Sets flatpaks to update twice a day
- Everything else (desktop, artwork, etc) remains stock so you can use this as a good starting image

## Applications

- All applications installed per user instead of system wide, similar to openSUSE MicroOS, they are not on the base image. Thanks for the inspiration Team Green!
- Mozilla Firefox, Extension Manager, Libreoffice, Pika, FontDownloader, Flatseal, and the Celluloid Media Player
- Core GNOME Applications installed from Flathub
  - GNOME Calculator, Calendar, Characters, Connections, Contacts, Evince, Firmware, Logs, Maps, NautilusPreviewer, TextEditor, Weather, baobab, clocks, eog, and font-viewer

## Further Customization

The `just` task runner is included for further customization after first boot.
It will copy the template from `/etc/justfile` to your home directory.
After that run the following commands:

- `just` - Show all tasks, more will be added in the future
- `just bios` - Reboot into the system bios (Useful for dualbooting)
- `just changelogs` - Show the changelogs of the pending update
- Set up distroboxes for the following images:
  - `just distrobox-boxkit`
  - `just distrobox-debian`
  - `just distrobox-opensuse`
  - `just distrobox-ubuntu`
- `just setup-flatpaks` - Install a selection of flatpaks, use this section to add your own apps
- `just setup-firefox` - Installs the [firefox gnome theme](https://github.com/rafaelmardojai/firefox-gnome-theme)
- `just update` - Update rpm-ostree, flatpaks, and distroboxes in one command

Check the [just website](https://just.systems) for tips on modifying and adding your own recipes. 
  
  
## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/iamcult/cultos
