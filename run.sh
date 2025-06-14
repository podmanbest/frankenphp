#!/bin/sh
# Build images

podman build -t frankenphp:1.7.0 ./1.7.0

# Run test
podman run -dt --name frankenphp -p 80:80 frankenphp:1.7.0

# Login 
podman exec -it frankenphp sh