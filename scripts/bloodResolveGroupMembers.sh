#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"

echo "[+] Started bloodResolveGroupMembers"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

scripts/bloodSids.sh "$INDIR" "$OUTDIR"

scripts/bloodGroupMembers.sh "$INDIR" "$OUTDIR"

echo "[~] Mapping SIDs data for each group member..."

join -j 1 -t ',' "$OUTDIR/membersids.csv" "$OUTDIR/sids.csv" >> "$OUTDIR/groupmembers.csv"

echo "[+] Done"
