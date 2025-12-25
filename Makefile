.PHONY: gen gen-local

# Configuration
FILES = -f services/base.yaml -f services/add-postgres.yaml -f services/add-server.yaml -f services/add-nginx.yaml
REMOTE_IMAGE = ghcr.io/mglmc/sendthenoise-server:latest
LOCAL_IMAGE = docker.io/library/sendthenoise:latest

# OS and Shell Detection
ifeq ($(OS),Windows_NT)
    GEN_CMD = powershell -ExecutionPolicy Bypass -File scripts/gen_compose.ps1
else
    GEN_CMD = ./scripts/gen_compose.sh
    _ := $(shell chmod +x scripts/gen_compose.sh)
endif

# Generate docker-compose.yaml with remote images
gen:
	$(GEN_CMD) $(REMOTE_IMAGE)

# Generate docker-compose.yaml with local images
gen-local:
	$(GEN_CMD) $(LOCAL_IMAGE)