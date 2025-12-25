#!/bin/bash
set -e

IMAGE_NAME=$1
if [ -z "$IMAGE_NAME" ]; then
    echo "Error: Image name argument required"
    exit 1
fi

export SERVER_IMAGE_NAME=$IMAGE_NAME

# Generate config and remove build section (we only use pre-built images)
docker compose -f services/base.yaml -f services/add-postgres.yaml -f services/add-server.yaml -f services/add-nginx.yaml -f services/add-mathesar.yaml config | \
awk '
    /^[[:space:]]*build:/ { skip = 1; indent = match($0, /[^ ]/) - 1; next }
    skip && /^[[:space:]]/ {
        current_indent = match($0, /[^ ]/) - 1
        if (current_indent > indent || /^[[:space:]]*$/) next
        skip = 0
    }
    { print }
' > docker-compose.yaml

echo "Generated docker-compose.yaml for $IMAGE_NAME"
