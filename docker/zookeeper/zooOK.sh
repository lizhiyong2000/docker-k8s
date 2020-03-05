#!/usr/bin/env bash


ZOO_PORT=${ZOO_PORT:-2181}
OK=$(echo ruok | nc 127.0.0.1 $ZOO_PORT)
if [ "$OK" == "imok" ]; then
	exit 0
else
	exit 1
fi