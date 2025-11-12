FROM nextcloud:31.0.4-apache

ARG MIRROR=
ARG DEBIAN_MIRROR=${MIRROR:+${MIRROR}/debian}
ARG DEBIAN_SECURITY_MIRROR=${MIRROR:+${MIRROR}/debian-security}

RUN [ -z "${DEBIAN_MIRROR}" ] || \
    sed -e "s|https\?://deb\.debian\.org/debian\$|${DEBIAN_MIRROR}|g" \
      -i \
      $([ -e "/etc/apt/sources.list.d/debian.sources" ] && \
        echo -n /etc/apt/sources.list.d/debian.sources || \
        echo -n /etc/apt/sources.list)

RUN [ -z "${DEBIAN_SECURITY_MIRROR}" ] || \
    sed -E -e "s|https?://(security\|deb)\.debian\.org/debian-security\$|${DEBIAN_SECURITY_MIRROR}|g" \
      -i \
      $([ -e "/etc/apt/sources.list.d/debian.sources" ] && \
        echo -n /etc/apt/sources.list.d/debian.sources || \
        echo -n /etc/apt/sources.list)

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists/ \
    set -ex; \
    DEBIAN_VERSION=$(cat /etc/debian_version); \
    curl -o /tmp/cuda-keyring_1.1-1_all.deb \
        https://developer.download.nvidia.com/compute/cuda/repos/debian${DEBIAN_VERSION%%.*}/$(arch)/cuda-keyring_1.1-1_all.deb; \
    dpkg -i /tmp/cuda-keyring_1.1-1_all.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        nodejs \
        aria2 \
        youtube-dl \
        ffmpeg \
        libmagickcore-6.q16-6-extra \
        procps \
        smbclient \
        supervisor \
        cuda-toolkit \
        libcudnn9-cuda-12 \
    ;

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists/ \
    set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libc-client-dev \
        libkrb5-dev \
#        libsmbclient-dev \
    ; \
    \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install \
        bz2 \
        imap \
    ; \
#    pecl install smbclient; \
#    docker-php-ext-enable smbclient; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord \
;

COPY supervisord.conf /

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
