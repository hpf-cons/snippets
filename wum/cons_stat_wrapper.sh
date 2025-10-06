#!/usr/bin/env bash

declare -a okmounts
while read _ _ mount _; do
	if ! timeout -k 9 5 /usr/local/sbin/cons_stat_smount.sh "$mount"; then
		printf 'ERROR: Mount timeout on %b!\n' "$mount" >&2
		exit 1
	else
		okmounts=( ${okmounts[@]} "$mount" )
	fi
done < <(mount -t cifs)

printf 'Mounts OK: %b\n' "${okmounts[*]}"
