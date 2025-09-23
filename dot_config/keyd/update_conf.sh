#!/usr/bin/env bash

set -x

cd "$(dirname "$0" | xargs realpath)" || exit 1

cp ./default.conf /etc/keyd/
