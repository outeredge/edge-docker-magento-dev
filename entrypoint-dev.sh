#!/bin/bash -e

CURRENT_UID="$(id -u)"
CURRENT_GID="$(id -g)"

if [ ${CURRENT_GID} -ne 1000 ]; then
  if ! whoami &> /dev/null; then
    echo "edge:x:${CURRENT_UID}:0:edge:/home/edge:/bin/bash" >> /etc/passwd
  fi
fi

exec "$@"
