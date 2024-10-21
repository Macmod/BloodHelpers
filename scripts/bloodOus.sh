#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/ous.csv
> $OUTDIR/gplinks.csv

echo "[+] Started bloodOUs"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

echo "[~] Analyzing OUs..."
for x in $INDIR/*_ous*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"guid": .ObjectIdentifier, "name": .Properties.name, "created": .Properties.whencreated, "dn": .Properties.distinguishedname, "desc": .Properties.description, "highvalue": .Properties.highvalue} | [.guid, .name, .created, .dn, .desc, .highvalue] | @csv' $x >> $OUTDIR/ous.csv
    jq -rc '.data[] | {"guid": .ObjectIdentifier, "gplink": .Links[].GUID} | [.guid, .gplink] | @csv' $x >> $OUTDIR/gplinks.csv
done

echo "[~] Sorting OU data..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/ous.csv > $tmpfile
mv $tmpfile $OUTDIR/ous.csv

echo "[~] Sorting GPLinks data..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/gplinks.csv > $tmpfile
mv $tmpfile $OUTDIR/gplinks.csv

echo "[+] Done"
