#!/bin/bash
set -e

REPO="ghcr.io/mglmc/sendthenoise-server"
TAG="latest"

while [[ $# -gt 0 ]]; do
    case $1 in
        -local)
            REPO="docker.io/library/sendthenoise"
            shift
            ;;
        -demo)
            TAG="demo"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

export SERVER_IMAGE_NAME="${REPO}:${TAG}"

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
