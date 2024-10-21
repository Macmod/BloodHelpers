#!/bin/bash

INDIR="$1"

OUTDIR="${2:-output}"
mkdir -p $OUTDIR
> $OUTDIR/membersids.csv

echo "[~] Fetching members of groups..."
for x in $INDIR/*_groups*.json; do
    echo "[~] Processing '$x'"
    jq -rc '.data[] | {"name": .Properties.samaccountname, "member": .Members[]} | {"name": .name, "memberSid": .member.ObjectIdentifier, "memberType": .member.ObjectType} | [.memberSid, .memberType, .name] | @csv' $x >> $OUTDIR/membersids.csv
done

echo "[~] Sorting SIDs..."
tmpfile=$(mktemp)
sort -t',' -k1b,1 $OUTDIR/membersids.csv | uniq > $tmpfile
mv $tmpfile $OUTDIR/membersids.csv

echo "[+] Done"
