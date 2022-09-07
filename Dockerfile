FROM casjaysdevdocker/alpine:latest as build

ARG LICENSE=WTFPL \
  IMAGE_NAME=music \
  TIMEZONE=America/New_York \
  PORT=

ENV SHELL=/bin/bash \
  TERM=xterm-256color \
  HOSTNAME=${HOSTNAME:-casjaysdev-$IMAGE_NAME} \
  TZ=$TIMEZONE

RUN mkdir -p /bin/ /config/ /data/ && \
  rm -Rf /bin/.gitkeep /config/.gitkeep /config/*/.gitkeep /data/.gitkeep /data/*/.gitkeep && \
  sed -i 's|3.16|edge|g' /etc/apk/repositories && \
  apk update -U --no-cache && \
  apk add mpd navidrome nginx

COPY ./bin/. /usr/local/bin/
COPY ./config/. /config/
COPY ./data/. /data/

FROM scratch
ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')"

LABEL org.label-schema.name="music" \
  org.label-schema.description="Containerized version of music" \
  org.label-schema.url="https://hub.docker.com/r/casjaysdevdocker/music" \
  org.label-schema.vcs-url="https://github.com/casjaysdevdocker/music" \
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
  HOSTNAME="casjaysdev-music" \
  TZ="${TZ:-America/New_York}"

WORKDIR /root

VOLUME ["/config","/data"]

EXPOSE $PORT

COPY --from=build /. /

ENTRYPOINT [ "tini", "--" ]
HEALTHCHECK CMD [ "/usr/local/bin/entrypoint-music.sh", "healthcheck" ]
CMD [ "/usr/local/bin/entrypoint-music.sh" ]
