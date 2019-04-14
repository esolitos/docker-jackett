# FROM  mcr.microsoft.com/dotnet/core/sdk:2.2-alpine3.9
#
# ARG JACKETT_VER
# # ARG JACKETT_VERSION="master"
# # ARG JACKETT_VERSION="v0.11.219"
#
# ENV JACKETT_VER="${JACKETT_VER:-master}" \
#   JACKET_REPO="https://github.com/Jackett/Jackett/releases"
#
# RUN set -ex ; \
#   \
#   apk add --no-cache git bash curl musl\>1.1.20; \
#   apk add --no-cache --virtual=.build-dependencies ca-certificates ; \
#   \
#   apk add --no-cache mono-dev musl --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
#   cert-sync /etc/ssl/certs/ca-certificates.crt ; \
#   \
#   git clone --branch "${JACKETT_VER}" https://github.com/Jackett/Jackett.git ; \
#   cd Jackett && ./build.sh --target=Linux ; \
#   apk del --purge .build-dependencies git bash curl ;

# RUN set -ex ; \
#   \
#   apk add --no-cache git ; \
#   git clone --depth=1 --branch "${JACKETT_VER}" https://github.com/Jackett/Jackett.git ; \
#   cd Jackett/src ; \
#   dotnet publish Jackett.Server -f netcoreapp2.2 --self-contained -r linux-x64 -c Debug ;

#
# FROM esolitos/alpine-mono
# FROM mono
# FROM mono:5.20.1
FROM mono:5.20.1-slim
# FROM mono:5.18.1

ARG JACKETT_VER
# ARG JACKETT_VERSION="latest"
# ARG JACKETT_VERSION="v0.11.219"

ENV JACKETT_VER="${JACKETT_VER:-latest}" \
  JACKETT_ARCHIVE="Jackett.Binaries.Mono.tar.gz" \
  JACKET_REPO="https://github.com/Jackett/Jackett/releases"

RUN set -ex ; \
  \
  apt-get update && apt-get install --no-install-recommends --no-upgrade --yes wget ; \
  \
  addgroup --gid 1000 --system jackett ; \
	adduser --uid 1000 --gid 1000 --disabled-password --system --shell /bin/bash jackett ; \
  # addgroup -g 1000 -S jackett ; \
	# adduser -u 1000 -D -S -s /bin/bash -G jackett jackett ; \
	# sed -i '/^jackett/s/!/*/' /etc/shadow ; \
	echo "PS1='\w\$ '" >> /home/jackett/.bashrc ; \
  \
  if [ "${JACKETT_VER:-}" = 'latest' ] ; \
  then url="${JACKET_REPO}/latest/download/${JACKETT_ARCHIVE}" ; \
  else url="${JACKET_REPO}/download/v${JACKETT_VER}/${JACKETT_ARCHIVE}" ; fi; \
  \
  mkdir -p /app/jackett && \
  wget -qO-  "${url}" | tar xz -C /app/jackett --strip-components=1 ; \
  \
  mkdir /config /downloads && \
  chown -R jackett:jackett /app /config /downloads ; \
  \
  apt-get remove --purge --auto-remove --yes wget && apt-get clean --yes ; \
  \
  echo "***** Done *****"

USER jackett

VOLUME /config /downloads
EXPOSE 9117

CMD ["mono", "--debug", "/app/jackett/JackettConsole.exe", "--NoUpdates", "--NoRestart"]

# https://github.com/Jackett/Jackett/releases/latest/download/Jackett.Binaries.LinuxAMDx64.tar.gz
# https://github.com/Jackett/Jackett/releases/download/v0.11.219/Jackett.Binaries.LinuxAMDx64.tar.gz
#
# https://github.com/Jackett/Jackett/releases/download/$JACKETT_VERSION/Jackett.Binaries.$JACKETT_ARCH.tar.gz
