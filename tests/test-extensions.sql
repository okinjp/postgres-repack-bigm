CREATE EXTENSION IF NOT EXISTS pg_repack;
CREATE EXTENSION IF NOT EXISTS pg_bigm;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

SELECT extname
FROM pg_extension
WHERE extname IN ('pg_repack', 'pg_bigm', 'pg_trgm', 'pg_stat_statements')
ORDER BY extname;
