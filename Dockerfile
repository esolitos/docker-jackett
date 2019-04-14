FROM mono:5.20.1

ARG VERSION
# ARG VERSION="0.11.219"

ENV XDG_DATA_HOME="/mnt/data" \
  XDG_CONFIG_HOME="/mnt/config" \
  \
  JACKETT_VER="${VERSION:-latest}" \
  JACKETT_ARCHIVE="Jackett.Binaries.Mono.tar.gz" \
  JACKET_REPO="https://github.com/Jackett/Jackett/releases"

RUN set -xeuf ; \
  \
  apt-get update && apt-get install --no-install-recommends --no-upgrade --yes wget ; \
  \
  addgroup --gid 1000 --system jackett && \
	 adduser --uid 1000 --gid 1000 --disabled-password --disabled-login --system jackett ; \
  \
  if [ "${JACKETT_VER:-}" = 'latest' ] ; \
    then url="${JACKET_REPO}/latest/download/${JACKETT_ARCHIVE}" ; \
    else url="${JACKET_REPO}/download/v${JACKETT_VER}/${JACKETT_ARCHIVE}" ; \
  fi ; \
  \
  mkdir -p /var/app /mnt/data /mnt/config && \
    wget -qO-  "${url}" | tar xz -C /var/app --strip-components=1 && \
      chown -vR jackett:jackett /var/app /mnt/data /mnt/config ; \
  \
  apt-get remove --purge --auto-remove --yes wget && \
    apt-get clean --yes && \
      rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/* ;

USER jackett

VOLUME ["/mnt/data", "/mnt/config"]

EXPOSE 9117
