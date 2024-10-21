#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/groups.csv

echo "[+] Started bloodGroups"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

echo "[~] Analyzing groups..."
for x in $INDIR/*_groups*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"sam": .Properties.samaccountname, "sid": .ObjectIdentifier, "created": .Properties.whencreated, "dn": .Properties.distinguishedname, "desc": .Properties.description, "enabled": .Properties.enabled, "highvalue": .Properties.highvalue, "nmembers": .Members|length} | [.sid, .sam, .created, .dn, .desc, .highvalue, .nmembers] | @csv' $x >> $OUTDIR/groups.csv
done

echo "[~] Sorting groups data..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/groups.csv > $tmpfile
mv $tmpfile $OUTDIR/groups.csv

echo "[+] Done"
