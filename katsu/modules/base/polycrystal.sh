#!/bin/bash -x
set -euo pipefail

cleanup() {
    for mnt in sys proc; do
        umount /mnt/mock-mount/$mnt
    done
    umount /mnt/mock-mount
    umount /mnt/mock-mount
}

if [ -x "$(command -v polycrystal)" ]; then
    trap cleanup EXIT
    mkdir -p /mnt/mock-mount
    mount --bind / /mnt/mock-mount
    mount --make-private /mnt/mock-mount
    mount --bind /mnt/mock-mount /mnt/mock-mount
    for mnt in proc sys; do
        mount --bind /$mnt /mnt/mock-mount/$mnt
    done

    chroot /mnt/mock-mount bash -c 'env GPGME_DEBUG=9 polycrystal'
fi
