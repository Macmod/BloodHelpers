#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/containers.csv

echo "[+] Started bloodContainers"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

echo "[~] Analyzing containers..."
for x in $INDIR/*_containers*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"guid": .ObjectIdentifier, "name": .Properties.name, "created": .Properties.whencreated, "dn": .Properties.distinguishedname, "desc": .Properties.description, "highvalue": .Properties.highvalue} | [.guid, .name, .created, .dn, .desc, .highvalue] | @csv' $x >> $OUTDIR/containers.csv
done

echo "[~] Sorting container data..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/containers.csv > $tmpfile
mv $tmpfile $OUTDIR/containers.csv

echo "[+] Done"
