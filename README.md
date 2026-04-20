# pg-repack-bigm (PostgreSQL 18)

PostgreSQL 18 ベースで、以下の拡張を利用できる Docker イメージ

- pg_repack
- pg_bigm
- pg_trgm
- pg_stat_statements

Docker Hub:

- [docker.io/okin/postgres-repack-bigm](https://hub.docker.com/repository/docker/okin/postgres-repack-bigm)

## 公開タグ

- Debian系: latest, debian, vX.Y.Z-debian, X.Y-debian, sha-xxxxxxx-debian
- Alpine系: alpine, vX.Y.Z-alpine, X.Y-alpine, sha-xxxxxxx-alpine

## Arch

- 現在: linux/amd64, linux/arm64

## ビルド

環境変数
- PG_REPACK_REF (default: ver_1.5.2)
- PG_BIGM_REF (default: v1.2-20250903)


Debian版:

```bash
docker build \
  --build-arg PG_REPACK_REF=ver_1.5.3 \
  --build-arg PG_BIGM_REF=v1.2-20250903 \
  -t okin/postgres-repack-bigm:local-debian \
  -f Dockerfile .
```

Alpine版:

```bash
docker build \
  --build-arg PG_REPACK_REF=ver_1.5.3 \
  --build-arg PG_BIGM_REF=v1.2-20250903 \
  -t okin/postgres-repack-bigm:local-alpine \
  -f Dockerfile.alpine .
```

## ローカル実行

Debian版:

```bash
docker run --name pg18-ext-debian \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -d okin/postgres-repack-bigm:latest \
  -c shared_preload_libraries=pg_stat_statements
```

Alpine版:

```bash
docker run --name pg18-ext-alpine \
  -e POSTGRES_PASSWORD=postgres \
  -p 5433:5432 \
  -d okin/postgres-repack-bigm:alpine \
  -c shared_preload_libraries=pg_stat_statements
```

## 拡張有効化

```sql
CREATE EXTENSION IF NOT EXISTS pg_repack;
CREATE EXTENSION IF NOT EXISTS pg_bigm;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

## リンク

- [github.com/okinjp/postgres-repack-bigm](https://github.com/postgres-repack-bigm)
- [docker.io/okin/postgres-repack-bigm](https://hub.docker.com/repository/docker/okin/postgres-repack-bigm)

