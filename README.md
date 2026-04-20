# pg-repack-bigm (PostgreSQL 18)

PostgreSQL 18 ベースで、以下の拡張を利用できる Docker イメージです。

- pg_repack
- pg_bigm
- pg_trgm
- pg_stat_statements

Docker Hub:

- okin/postgres-repack-bigm

## 公開タグ

- Debian系: latest, debian, vX.Y.Z-debian, X.Y-debian, sha-xxxxxxx-debian
- Alpine系: alpine, vX.Y.Z-alpine, X.Y-alpine, sha-xxxxxxx-alpine

## Arch

- 現在: linux/amd64, linux/arm64

## ビルド

環境変数
- PG_REPACK_REF (default: ver_1.5.2)
- PG_BIGM_REF (default: v1.2-20250903)

GitHub Actions での手動検証:

- `.github/workflows/docker-build-push.yml` の `workflow_dispatch` から
  `pg_repack_ref` と `pg_bigm_ref` を指定可能
- 指定時は smoke test / publish ともに指定値をビルド引数として利用

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
