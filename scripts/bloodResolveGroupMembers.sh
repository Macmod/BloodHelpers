#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"

echo "[+] Started bloodResolveGroupMembers"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

scripts/bloodSids.sh "$INDIR"

scripts/bloodGroupMembers.sh "$INDIR"

echo "[~] Mapping SIDs data for each group member..."

join -j 1 -t ',' $OUTDIR/membersids.csv $OUTDIR/sids.csv >> $OUTDIR/groupmembers.csv

echo "[+] Done"
