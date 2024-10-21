#!/bin/bash

INDIR="$1"
OUTDIR="${2:-output}"

if [ ! -d "$INDIR" ]; then
    echo "Invalid input directory provided.";
    exit 1;
fi

mkdir -p "$OUTDIR"

scripts/bloodResolveGroupMembers.sh "$INDIR" "$OUTDIR"

scripts/bloodUsers.sh "$INDIR" "$OUTDIR"

scripts/bloodGroups.sh "$INDIR" "$OUTDIR"

scripts/bloodComputers.sh "$INDIR" "$OUTDIR"

scripts/bloodContainers.sh "$INDIR" "$OUTDIR"

scripts/bloodGpos.sh "$INDIR" "$OUTDIR"

scripts/bloodOus.sh "$INDIR" "$OUTDIR"
