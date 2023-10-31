FROM jellyfin/jellyfin

RUN sed -e 's|deb\.debian\.org|opentuna.cn|g' \
        -e 's|security\.debian\.org|opentuna.cn|g' \
        -e 's|http://opentuna\.cn|https://opentuna.cn|g' \
      -i.bak \
      $([ -e "/etc/apt/sources.list.d/debian.sources" ] && \
        echo -n /etc/apt/sources.list.d/debian.sources || \
        echo -n /etc/apt/sources.list)

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        fonts-noto-cjk-extra \
    ; \
    rm -rf /var/lib/apt/lists/*
