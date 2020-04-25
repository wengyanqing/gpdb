MODULE_big = gp_timeseries

EXTENSION = gp_timeseries
DATA = gp_timeseries--1.0.sql

OBJS       = gp_timeseries.o time_bucket.o utils.o
PG_CPPFLAGS = -I$(libpq_srcdir)

ifdef USE_PGXS
PGXS := $(shell pg_config --pgxs)
include $(PGXS)
else
subdir = contrib/gp_timeseries
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif

