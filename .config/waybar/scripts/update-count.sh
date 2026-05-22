#!/usr/bin/env bash

if command -v checkupdates >/dev/null 2>&1; then
    checkupdates 2>/dev/null | wc -l
else
    printf '0\n'
fi
