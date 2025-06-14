#!/bin/sh
if [ ! -d "data/*" ]; then
  mkdir -p data/mysql data/logs/mysql
fi

# Check Pods
if podman pod exists laravel ; then
    podman pod rm -f laravel 
fi
podman pod create --name laravel -p 8080:80

# Remove old images
if podman image exists php; then
  podman rmi -f app 2>/dev/null || true
fi

# Build images
sh buildah.sh

# Run test
podman run -dt --name frankenphp -p 80:80 frankenphp:1.7.0

