FROM postgres:18-bookworm AS builder

ARG PG_REPACK_REF=ver_1.5.3
ARG PG_BIGM_REF=v1.2-20250903
ARG PGROONGA_REF=4.0.8

# Build extension artifacts against PostgreSQL 18 headers.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        gnupg \
        libgroonga-dev \
        libicu-dev \
        liblz4-dev \
        libnuma-dev \
        libreadline-dev \
        libzstd-dev \
        meson \
        ninja-build \
        zlib1g-dev \
        postgresql-server-dev-18; \
    apt-get install -y --no-install-recommends ruby; \
    curl -fsSL https://packages.groonga.org/debian/groonga-apt-source-latest-bookworm.deb -o /tmp/groonga-apt-source.deb; \
    dpkg -i /tmp/groonga-apt-source.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends libgroonga-dev; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /tmp/build; \
    cd /tmp/build; \
    git clone --depth 1 --branch "${PG_REPACK_REF}" https://github.com/reorg/pg_repack.git; \
    cd pg_repack; \
    make; \
    make install; \
    cd /tmp/build; \
    git clone --depth 1 --branch "${PG_BIGM_REF}" https://github.com/pgbigm/pg_bigm.git; \
    cd pg_bigm; \
    make USE_PGXS=1; \
    make USE_PGXS=1 install; \
    cd /tmp/build; \
    git clone --depth 1 --branch "${PGROONGA_REF}" https://github.com/pgroonga/pgroonga.git; \
    cd pgroonga; \
    meson setup build --prefix=/usr/local --libdir=/usr/local/lib/postgresql --datadir=/usr/local/share/postgresql --bindir=/usr/local/bin -Dinstall_to_postgresql=true; \
    ninja -C build; \
    ninja -C build install; \
    rm -rf /tmp/build

FROM postgres:18-bookworm

# pg_bigm needs ICU at runtime.
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg; \
    curl -fsSL https://packages.groonga.org/debian/groonga-apt-source-latest-bookworm.deb -o /tmp/groonga-apt-source.deb; \
    dpkg -i /tmp/groonga-apt-source.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libgroonga0 \
        libicu72 \
        liblz4-1 \
        libnuma1 \
        libreadline8 \
        libzstd1 \
        zlib1g; \
    rm -rf /var/lib/apt/lists/*

# Copy only required extension artifacts from builder.
COPY --from=builder /usr/lib/postgresql/18/lib/pg_repack.so /usr/lib/postgresql/18/lib/pg_repack.so
COPY --from=builder /usr/lib/postgresql/18/lib/pg_bigm.so /usr/lib/postgresql/18/lib/pg_bigm.so
COPY --from=builder /usr/lib/postgresql/18/lib/pgroonga.so /usr/lib/postgresql/18/lib/pgroonga.so
COPY --from=builder /usr/lib/postgresql/18/bin/pg_repack /usr/lib/postgresql/18/bin/pg_repack
COPY --from=builder /usr/share/postgresql/18/extension/pg_repack* /usr/share/postgresql/18/extension/
COPY --from=builder /usr/share/postgresql/18/extension/pg_bigm* /usr/share/postgresql/18/extension/
COPY --from=builder /usr/share/postgresql/18/extension/pgroonga* /usr/share/postgresql/18/extension/

LABEL org.opencontainers.image.title="PostgreSQL 18 with pg_repack, pg_bigm, and pgroonga" \
      org.opencontainers.image.description="Postgres 18 image with pg_repack, pg_bigm, pgroonga, and contrib extensions such as pg_trgm and pg_stat_statements." \
      org.opencontainers.image.source="https://github.com/okin/pg-repack-bigm"
