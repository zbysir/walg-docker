FROM golang:1.23-alpine AS builder

RUN set -ex \
     && apk add --no-cache wget cmake build-base git bash

# https://github.com/wal-g/wal-g/releases
ENV WALG_VERSION=v3.0.4
ENV BROTLI_VERSION=v1.0.9

# brotli offers 3x better compression than gzip.
# ENV USE_BROTLI will affect the make deps step.
ENV USE_BROTLI=true

# Brotli

RUN set -ex \
     && cd /tmp \
     && wget -qO - https://github.com/google/brotli/archive/${BROTLI_VERSION}.tar.gz | tar xz -f '-' \
     && cd brotli* \
     && mkdir out \
     && cd out \
     && ../configure-cmake --disable-debug \
     && make \
     && make install

# WAL-G

RUN set -ex \
    && cd $GOPATH/src \
    && git clone --depth 1 -b "$WALG_VERSION" --single-branch https://github.com/wal-g/wal-g/ \
    && cd $GOPATH/src/wal-g/ \
    && make deps \
    && make pg_build \
    && install main/pg/wal-g /

FROM alpine
COPY --from=builder /wal-g ./
ENTRYPOINT ["./wal-g"]