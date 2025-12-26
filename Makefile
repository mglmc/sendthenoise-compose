.PHONY: gen gen-local gen-demo

# Configuration
FILES = -f services/base.yaml -f services/add-postgres.yaml -f services/add-server.yaml -f services/add-nginx.yaml

# OS and Shell Detection
ifeq ($(OS),Windows_NT)
    GEN_CMD = powershell -ExecutionPolicy Bypass -File scripts/gen_compose.ps1
else
    GEN_CMD = ./scripts/gen_compose.sh
    _ := $(shell chmod +x scripts/gen_compose.sh)
endif

# Arguments as targets
OPTIONS = local demo
$(OPTIONS):
	@:

# Generate docker-compose.yaml
# Usage: make gen local demo
gen:
	$(GEN_CMD) $(addprefix -,$(filter-out gen,$(MAKECMDGOALS)))