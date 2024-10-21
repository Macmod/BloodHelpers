#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/gpos.csv

echo "[+] Started bloodGPOs"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

echo "[~] Analyzing GPOs..."
for x in $INDIR/*_gpos*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"guid": .ObjectIdentifier, "name": .Properties.name, "created": .Properties.whencreated, "dn": .Properties.distinguishedname, "desc": .Properties.description, "highvalue": .Properties.highvalue} | [.guid, .name, .created, .dn, .desc, .highvalue] | @csv' $x >> $OUTDIR/gpos.csv
done

echo "[~] Sorting GPO data..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/gpos.csv > $tmpfile
mv $tmpfile $OUTDIR/gpos.csv

echo "[+] Done"
