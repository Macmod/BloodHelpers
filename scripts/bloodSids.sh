#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/sids.csv

echo "[+] Started bloodSids"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

echo "[~] Grabbing SIDs for computers..."
for x in $INDIR/*_computers*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"name": .Properties.samaccountname, "sid": .ObjectIdentifier} | [.sid, .name] | @csv' $x >> $OUTDIR/sids.csv
done

echo "[~] Grabbing SIDs for users..."
for x in $INDIR/*_users*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"name": .Properties.samaccountname, "sid": .ObjectIdentifier} | [.sid, .name] | @csv' $x >> $OUTDIR/sids.csv
done

echo "[~] Grabbing SIDs for groups..."
for x in $INDIR/*_groups*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"name": .Properties.samaccountname, "sid": .ObjectIdentifier} | [.sid, .name] | @csv' $x >> $OUTDIR/sids.csv
done

echo "[~] Sorting SIDs..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/sids.csv > $tmpfile
mv $tmpfile $OUTDIR/sids.csv

echo "[+] Done"
