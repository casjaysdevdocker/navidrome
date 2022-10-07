FROM casjaysdevdocker/alpine:latest as build

ARG alpine_version=edge

ARG LICENSE=WTFPL \
  IMAGE_NAME=navidrome \
  TIMEZONE=America/New_York \
  PORT=80

ENV SHELL=/bin/bash \
  TERM=xterm-256color \
  HOSTNAME=${HOSTNAME:-casjaysdev-$IMAGE_NAME} \
  TZ=$TIMEZONE

RUN mkdir -p /bin/ /config/ /data/ && \
  rm -Rf /bin/.gitkeep /config/.gitkeep /config/*/.gitkeep /data/.gitkeep /data/*/.gitkeep /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/$alpine_version/main" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/$alpine_version/community" >> /etc/apk/repositories && \
  echo "http://dl-cdn.alpinelinux.org/alpine/$alpine_version/testing" >> /etc/apk/repositories && \
  apk update -U --no-cache && \
  apk add --no-cache mpd mpc navidrome && \
  rm -Rf /etc/mpd.conf

COPY ./bin/. /usr/local/bin/
COPY ./config/. /etc/
COPY ./data/. /data/

FROM scratch
ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')"

LABEL org.label-schema.name="navidrome" \
  org.label-schema.description="Containerized version of navidrome" \
  org.label-schema.url="https://hub.docker.com/r/casjaysdevdocker/navidrome" \
  org.label-schema.vcs-url="https://github.com/casjaysdevdocker/navidrome" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="$LICENSE" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="latest" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>"

ENV SHELL="/bin/bash" \
  TERM="xterm-256color" \
  HOSTNAME="casjaysdev-navidrome" \
  TZ="${TZ:-America/New_York}"

WORKDIR /root

VOLUME ["/config","/data"]

EXPOSE $PORT

COPY --from=build /. /

ENTRYPOINT [ "tini", "--" ]
HEALTHCHECK --interval=15s --timeout=3s CMD [ "/usr/local/bin/entrypoint-navidrome.sh", "healthcheck" ]
CMD [ "/usr/local/bin/entrypoint-navidrome.sh" ]
