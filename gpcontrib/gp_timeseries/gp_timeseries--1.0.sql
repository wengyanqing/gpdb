/* contrib/gp_distribution_policy/gp_distribution_policy--1.0.sql */

-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION gp_timeseries" to load this file. \quit

-- time_bucket returns the left edge of the bucket where ts falls into.
-- Buckets span an interval of time equal to the bucket_width and are aligned with the epoch.
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts TIMESTAMP) RETURNS TIMESTAMP
    AS '$libdir/gp_timeseries', 'ts_timestamp_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

-- bucketing of timestamptz happens at UTC time
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts TIMESTAMPTZ) RETURNS TIMESTAMPTZ
    AS '$libdir/gp_timeseries', 'ts_timestamptz_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

--bucketing on date should not do any timezone conversion
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts DATE) RETURNS DATE
    AS '$libdir/gp_timeseries', 'ts_date_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

--bucketing with origin
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts TIMESTAMP, origin TIMESTAMP) RETURNS TIMESTAMP
    AS '$libdir/gp_timeseries', 'ts_timestamp_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts TIMESTAMPTZ, origin TIMESTAMPTZ) RETURNS TIMESTAMPTZ
    AS '$libdir/gp_timeseries', 'ts_timestamptz_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts DATE, origin DATE) RETURNS DATE
    AS '$libdir/gp_timeseries', 'ts_date_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

-- bucketing of int
CREATE OR REPLACE FUNCTION time_bucket(bucket_width SMALLINT, ts SMALLINT) RETURNS SMALLINT
    AS '$libdir/gp_timeseries', 'ts_int16_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INT, ts INT) RETURNS INT
    AS '$libdir/gp_timeseries', 'ts_int32_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;
CREATE OR REPLACE FUNCTION time_bucket(bucket_width BIGINT, ts BIGINT) RETURNS BIGINT
    AS '$libdir/gp_timeseries', 'ts_int64_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

-- bucketing of int with offset
CREATE OR REPLACE FUNCTION time_bucket(bucket_width SMALLINT, ts SMALLINT, "offset" SMALLINT) RETURNS SMALLINT
    AS '$libdir/gp_timeseries', 'ts_int16_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INT, ts INT, "offset" INT) RETURNS INT
    AS '$libdir/gp_timeseries', 'ts_int32_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;
CREATE OR REPLACE FUNCTION time_bucket(bucket_width BIGINT, ts BIGINT, "offset" BIGINT) RETURNS BIGINT
    AS '$libdir/gp_timeseries', 'ts_int64_bucket' LANGUAGE C IMMUTABLE PARALLEL SAFE STRICT;

-- If an interval is given as the third argument, the bucket alignment is offset by the interval.
CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts TIMESTAMP, "offset" INTERVAL)
    RETURNS TIMESTAMP LANGUAGE SQL IMMUTABLE PARALLEL SAFE STRICT AS
$BODY$
    SELECT time_bucket(bucket_width, ts-"offset")+"offset";
$BODY$;

CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts TIMESTAMPTZ, "offset" INTERVAL)
    RETURNS TIMESTAMPTZ LANGUAGE SQL IMMUTABLE PARALLEL SAFE STRICT AS
$BODY$
    SELECT time_bucket(bucket_width, ts-"offset")+"offset";
$BODY$;

CREATE OR REPLACE FUNCTION time_bucket(bucket_width INTERVAL, ts DATE, "offset" INTERVAL)
    RETURNS DATE LANGUAGE SQL IMMUTABLE PARALLEL SAFE STRICT AS
$BODY$
    SELECT (time_bucket(bucket_width, ts-"offset")+"offset")::date;
$BODY$;
