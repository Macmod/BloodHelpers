#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/users.csv

echo "[+] Started bloodUsers"
echo "[+] INDIR=$INDIR"
echo "[+] OUTDIR=$OUTDIR"

echo "[~] Analyzing users..."

for x in $INDIR/*_users*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"sam": .Properties.samaccountname, "sid": .ObjectIdentifier, "created": .Properties.whencreated, "pwdlastset": .Properties.pwdlastset, "dn": .Properties.distinguishedname, "email": .Properties.email, "displayname": .Properties.displayname, "desc": .Properties.description, "title": .Properties.title, "enabled": .Properties.enabled} | [.sid,.enabled,.sam,.title,.created,.pwdlastset,.email,.dn,.displayname,.desc] | @csv' $x >> $OUTDIR/users.csv
done

echo "[~] Sorting user data..."
tmpfile=$(mktemp)
sort -u -t',' -k1b,1 $OUTDIR/users.csv > $tmpfile
mv $tmpfile $OUTDIR/users.csv

echo "[+] Done"
