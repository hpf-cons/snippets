#!/usr/bin/env bash

SYSLOG=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		'-l'|'--syslog')
			SYSLOG=1
			shift
		;;
		*)
			printf 'Unknown option: %b\n' "$1" >&2
			exit 127
		;;
	esac
done

declare -ax okmounts
while read _ _ mount _; do
	if ! timeout -k 9 5 /usr/local/sbin/cons_stat_smount.sh "$mount"; then
		case "$SYSLOG" in
			0)
				printf 'ERROR: Mount timeout on %b!\n' "$mount" >&2
			;;
			*)
				logger -p syslog.err -t cons_stat "Mount timeout on $mount"
			;;
		esac
		exit 1
	else
		okmounts=( ${okmounts[@]} "$mount" )
	fi
done < <(mount -t cifs)

case "$SYSLOG" in
	0)
		printf 'Mounts OK: %b\n' "${okmounts[*]}"
	;;
	*)
		logger -p syslog.info -t cons_stat "No CIFS mounts are stale."
	;;
esac
