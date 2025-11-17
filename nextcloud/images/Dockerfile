FROM nextcloud:31.0.7-fpm

ARG MIRROR=
ARG DEBIAN_MIRROR=${MIRROR:+${MIRROR}/debian}
ARG DEBIAN_SECURITY_MIRROR=${MIRROR:+${MIRROR}/debian-security}
# ARG DEBIAN_MULTIMEDIA_MIRROR=${MIRROR:+${MIRROR}/deb-multimedia}

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

RUN rm /etc/apt/apt.conf.d/docker-clean
RUN --mount=type=cache,target=/var/cache/apt \
	--mount=type=cache,target=/var/lib/apt/lists/ \
	--mount=type=tmpfs,target=/tmp \
	--mount=type=cache,target=/download \
	<<-EOF
	set -ex
	. /etc/os-release

	apt-get update
	[ -f /download/cuda-keyring_1.1-1_all.deb ] || curl -Lo /download/cuda-keyring_1.1-1_all.deb \
		https://developer.download.nvidia.com/compute/cuda/repos/debian${VERSION_ID}/$(arch)/cuda-keyring_1.1-1_all.deb
	apt-get install -y /download/cuda-keyring_1.1-1_all.deb

	architecture=$(dpkg --print-architecture)
	[ -f /download/jellyfin-ffmpeg7_7.1.2-4-${VERSION_CODENAME}_${architecture}.deb ] || curl -Lo /download/jellyfin-ffmpeg7_7.1.2-4-${VERSION_CODENAME}_${architecture}.deb \
		https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v7.1.2-4/jellyfin-ffmpeg7_7.1.2-4-${VERSION_CODENAME}_${architecture}.deb
	apt-get install -y /download/jellyfin-ffmpeg7_7.1.2-4-${VERSION_CODENAME}_${architecture}.deb

	ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg
    ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe

	# [ -f /download/deb-multimedia-keyring_2024.9.1_all.deb ] || curl -Lo /download/deb-multimedia-keyring_2024.9.1_all.deb \
	# 	${DEBIAN_MULTIMEDIA_MIRROR:-https://www.deb-multimedia.org}/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb
	# apt-get install -y /download/deb-multimedia-keyring_2024.9.1_all.deb
	# cat <<EEOF > /etc/apt/sources.list.d/deb-multimedia.list
	# # 默认注释了源码仓库，如有需要可自行取消注释
	# deb ${DEBIAN_MULTIMEDIA_MIRROR:-https://www.deb-multimedia.org} ${VERSION_CODENAME} main non-free
	# #deb-src ${DEBIAN_MULTIMEDIA_MIRROR:-https://www.deb-multimedia.org} ${VERSION_CODENAME} main non-free
	# deb ${DEBIAN_MULTIMEDIA_MIRROR:-https://www.deb-multimedia.org} ${VERSION_CODENAME}-backports main
	# #deb-src ${DEBIAN_MULTIMEDIA_MIRROR:-https://www.deb-multimedia.org} ${VERSION_CODENAME}-backports main
	# EEOF
EOF

RUN --mount=type=cache,target=/var/cache/apt \
	--mount=type=cache,target=/var/lib/apt/lists/ \
	--mount=type=tmpfs,target=/tmp \
	set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		cuda-runtime-13-0 \
	;

ADD --unpack=true https://github.com/nextcloud-releases/richdocuments/releases/download/v8.7.6/richdocuments-v8.7.6.tar.gz /usr/src/nextcloud/custom_apps/
ADD --unpack=true https://github.com/pulsejet/memories/releases/download/v7.7.0/memories.tar.gz /usr/src/nextcloud/custom_apps/

COPY hooks /docker-entrypoint-hooks.d
COPY config/* /usr/src/nextcloud/config/
