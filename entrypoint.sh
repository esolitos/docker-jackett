#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell "/bin/bash" --non-unique --comment "docker2local" --create-home --user-group --uid $USER_ID "user"

echo "Ensureing correct ownership for mount points."
chown -vR $USER_ID:$USER_ID /var/app /mnt/data /mnt/config

export HOME=/home/user

exec /usr/local/bin/gosu user "$@"
