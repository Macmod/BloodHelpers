#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/computers.csv

echo "[+] Started bloodComputers"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

echo "[~] Analyzing computers..."
for x in $INDIR/*_computers*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"sam": .Properties.samaccountname, "sid": .ObjectIdentifier, "created": .Properties.whencreated, "pwdlastset": .Properties.pwdlastset, "dn": .Properties.distinguishedname, "desc": .Properties.description, "enabled": .Properties.enabled, "haslaps": .Properties.haslaps, "os": .Properties.operatingsystem} | [.sid, .enabled, .haslaps, .sam, .created, .pwdlastset, .dn, .desc, .os] | @csv' $x >> $OUTDIR/computers.csv
done

echo "[~] Sorting computer data..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/computers.csv > $tmpfile
mv $tmpfile $OUTDIR/computers.csv

echo "[+] Done"
