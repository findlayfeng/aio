ARG NEXTCLOUD_VER=35.0.2

FROM scratch AS rootfs

ARG RICHDOCUMENTS_VER=12.0.1
ADD --unpack=true https://github.com/nextcloud-releases/richdocuments/releases/download/v${RICHDOCUMENTS_VER}/richdocuments-v${RICHDOCUMENTS_VER}.tar.gz /rootfs/usr/src/nextcloud/custom_apps/

ARG MEMORIES_VER=11.0.2
ADD --unpack=true https://github.com/pulsejet/memories/releases/download/v${MEMORIES_VER}/memories.tar.gz /rootfs/usr/src/nextcloud/custom_apps/

ARG NOTIFY_PUSH_VER=1.4.2
ADD --unpack=true https://github.com/nextcloud-releases/notify_push/releases/download/v${NOTIFY_PUSH_VER}/notify_push-v${NOTIFY_PUSH_VER}.tar.gz /rootfs/usr/src/nextcloud/custom_apps/

ARG JELLYFIN_FFMPEG_VER=8.1.3-2
ADD --unpack=true https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${JELLYFIN_FFMPEG_VER}/jellyfin-ffmpeg_${JELLYFIN_FFMPEG_VER}_portable_linux64-gpl.tar.xz /rootfs/usr/local/bin/

ARG PREVIEWGENERATOR_VER=5.15.0
ADD --unpack=true https://github.com/nextcloud-releases/previewgenerator/releases/download/v${PREVIEWGENERATOR_VER}/previewgenerator-v${PREVIEWGENERATOR_VER}.tar.gz /rootfs/usr/src/nextcloud/custom_apps/

COPY hooks /rootfs/docker-entrypoint-hooks.d
COPY config /rootfs/usr/src/nextcloud/config

FROM nextcloud:${NEXTCLOUD_VER}-fpm

COPY --from=rootfs /rootfs /

VOLUME [ "/var/www/skeleton" ]
