FRANKENPHP_VERSION=1.7.0

if podman image exists frankenphp:$FRANKENPHP_VERSION ; then
  podman rmi -f frankenphp:$FRANKENPHP_VERSION
fi

####################################################################
ctr=$(buildah from quay.io/libpod/alpine:latest)
buildah run $ctr -- apk add --no-cache curl
# Mount filesystem container
mnt=$(buildah mount $ctr)

cp ./$FRANKENPHP_VERSION/install.sh $mnt/tmp 
sh $mnt/tmp/install.sh; rm $mnt/tmp/install.sh 
rm -rf $mnt/var/cache/apk/*
mkdir /app

# Set working directory
buildah config --workingdir /app $ctr

# Buka port 80
buildah config --port 80 $ctr

# Set command default untuk FrankenPHP serve
#buildah config --cmd '["frankenphp", "serve"]' $ctr

# Tambahkan label informasi (opsional)
buildah config --label "maintainer=DevOps" $ctr

# Unmount dan commit image
buildah unmount $ctr
buildah commit $ctr localhost/frankenphp:1.7.0