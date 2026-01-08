#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "$0")/../.." && pwd)"
IMAGE="dotman-e2e"

docker build -t "$IMAGE" -f "$ROOT_DIR/dotman/e2e/Dockerfile" "$ROOT_DIR"
docker run --rm "$IMAGE"
