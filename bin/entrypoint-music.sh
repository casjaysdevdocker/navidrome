#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202209062132-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.com
# @@License          :  WTFPL
# @@ReadME           :  entrypoint-music.sh --help
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Tuesday, Sep 06, 2022 21:32 EDT
# @@File             :  entrypoint-music.sh
# @@Description      :
# @@Changelog        :  New script
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  other/docker-entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0" 2>/dev/null)"
VERSION="202209062132-git"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
[ "$1" == "--debug" ] && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "$1" == "--raw" ] && export SHOW_RAW="true"
set -o pipefail

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__version() { echo -e ${GREEN:-}"$VERSION"${NC:-}; }
__find() { ls -A "$*" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# colorization
[ -n "$SHOW_RAW" ] || printf_color() { echo -e '\t\t'${2:-}"${1:-}${NC}"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__exec_bash() {
  [ "$1" = "" ] && shift 1
  local cmd="${*:-/bin/bash}"
  local exitCode=0
  echo "Executing command: $cmd"
  $cmd || exitCode=10
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define default variables
TZ="${TZ:-America/New_York}"
HOSTNAME="${HOSTNAME:-casjaysdev-bin}"
BIN_DIR="${BIN_DIR:-/usr/local/bin}"
DATA_DIR="${DATA_DIR:-$(__find /data/ 2>/dev/null | grep '^' || false)}"
CONFIG_DIR="${CONFIG_DIR:-$(__find /config/ 2>/dev/null | grep '^' || false)}"
CONFIG_COPY="${CONFIG_COPY:-false}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Export variables
export TZ HOSTNAME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import variables from file
[ -f "/root/env.sh" ] && . "/root/env.sh"
[ -f "/config/.env.sh" ] && . "/config/.env.sh"
[ -f "/root/env.sh" ] && [ ! -f "/config/.env.sh" ] && cp -Rf "/root/env.sh" "/config/.env.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set timezone
[ -n "${TZ}" ] && echo "${TZ}" >/etc/timezone
[ -f "/usr/share/zoneinfo/${TZ}" ] && ln -sf "/usr/share/zoneinfo/${TZ}" "/etc/localtime"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set hostname
if [ -n "${HOSTNAME}" ]; then
  echo "${HOSTNAME}" >/etc/hostname
  echo "127.0.0.1 ${HOSTNAME} localhost ${HOSTNAME}.local" >/etc/hosts
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete any gitkeep files
[ -n "${CONFIG_DIR}" ] && { [ -d "${CONFIG_DIR}" ] && rm -Rf "${CONFIG_DIR}/.gitkeep" || mkdir -p "/config/"; }
[ -n "${DATA_DIR}" ] && { [ -d "${DATA_DIR}" ] && rm -Rf "${DATA_DIR}/.gitkeep" || mkdir -p "/data/"; }
[ -n "${BIN_DIR}" ] && { [ -d "${BIN_DIR}" ] && rm -Rf "${BIN_DIR}/.gitkeep" || mkdir -p "/bin/"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy config files to /etc
if [ -n "${CONFIG_DIR}" ] && [ "${CONFIG_COPY}" = "true" ]; then
  for config in ${CONFIG_DIR}; do
    if [ -d "/config/$config" ]; then
      [ -d "/etc/$config" ] || mkdir -p "/etc/$config"
      cp -Rf "/config/$config/." "/etc/$config/"
    elif [ -f "/config/$config" ]; then
      cp -Rf "/config/$config" "/etc/$config"
    fi
  done
fi
[ -f "/etc/.env.sh" ] && rm -Rf "/etc/.env.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional commands
[ -d "/data/mpd" ] || mkdir -p "/data/mpd"
[ -d "/data/music" ] || mkdir -p "/data/music"
[ -d "/data/navidrome" ] || mkdir -p "/data/navidrome"
[ -d "/data/playlists" ] || mkdir -p "/data/playlists"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -d "/config/mpd" ] || mkdir -p "/config/mpd"
[ -d "/config/navidrome" ] || mkdir -p "/config/navidrome"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -f "/config/mpd/mpd.conf" ] || cp -Rf "/etc/mpd.conf" "/config/mpd/mpd.conf"
[ -f "/config/navidrome/navidrome.toml" ] || cp -Rf "/etc/navidrome/navidrome.toml" "/config/navidrome/navidrome.toml"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if ! pgrep mpd &>/dev/null; then
  [ -f "/data/mpd/mpd.pid" ] && rm -Rf "/data/mpd/mpd.pid"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
chmod 777 -R /data/mpd /data/navidrome /data/music /data/playlists
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
case "$1" in
--help) # Help message
  echo 'Docker container for '$APPNAME''
  echo "Usage: $APPNAME [healthcheck, bash, command]"
  echo "Failed command will have exit code 10"
  echo
  exitCode=$?
  ;;

healthcheck) # Docker healthcheck
  pgrep mpd &>/dev/null &&
    pgrep nginx &>/dev/null &&
    pgrep navidrome &>/dev/null
  exit $?
  ;;

*/bin/sh | */bin/bash | bash | shell | sh) # Launch shell
  shift 1
  __exec_bash "${@:-/bin/bash}"
  exitCode=$?
  ;;

*) # Execute primary command
  if [ $# -eq 0 ]; then
    mpd "/config/mpd/mpd.conf"
    navidrome --configfile "/config/navidrome/navidrome.toml"
  else
    __exec_bash "$@"
  fi
  exitCode=$?
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end of entrypoint
exit ${exitCode:-$?}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
