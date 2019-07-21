FROM mono:5.20.1-slim

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
  apt-get update && apt-get install --no-install-recommends --no-upgrade --yes \
  wget gosu ; \
  \
  # Ensure gosu works.
  gosu nobody true ; \
  \
  if [ "${JACKETT_VER:-}" = 'latest' ] ; \
    then url="${JACKET_REPO}/latest/download/${JACKETT_ARCHIVE}" ; \
    else url="${JACKET_REPO}/download/v${JACKETT_VER}/${JACKETT_ARCHIVE}" ; \
  fi ; \
  \
  mkdir -p /var/app /mnt/data /mnt/config && \
    wget -qO-  "${url}" | tar xz -C /var/app --strip-components=1 ; \
  \
  apt-get remove --purge --auto-remove --yes wget && \
    apt-get clean --yes && \
      rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/* ;

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME ["/mnt/data", "/mnt/config"]

EXPOSE 9117

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
