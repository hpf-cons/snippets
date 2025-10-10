#!/usr/bin/env bash

/usr/bin/sudo /usr/bin/getent shadow | grep -vP '^[^:]+:[!x]?[\*!]?:'
