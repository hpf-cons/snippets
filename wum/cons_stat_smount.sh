#!/usr/bin/env bash

if [ -z "$1" ]; then
	printf 'No mountpoint specified!\n' >&2
	exit 101
fi
read -t1 < <(stat -t "$1") || lsof -b 2>/dev/null|grep "$1"
