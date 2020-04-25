#include "postgres.h"

#include "fmgr.h"
#include "funcapi.h"
#include "utils/builtins.h"
#include "utils/snapmgr.h"
#include "cdb/cdbhash.h"
#include "cdb/cdbvars.h"
#include "utils/lsyscache.h"
#include "miscadmin.h"
#include "catalog/gp_policy.h"
#include "utils/array.h"
#include "utils/tqual.h"


#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif
