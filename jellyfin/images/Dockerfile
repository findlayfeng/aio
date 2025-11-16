FROM jellyfin/jellyfin

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
	--mount=type=tmpfs,target=/tmp \
	set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		fonts-noto-cjk-extra \
	;
