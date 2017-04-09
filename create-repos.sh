#!/bin/bash
#
# Create input repos in Pachyderm.

# Be paranoid about errors.
set -euo pipefail

create-repo() {
    local name="$1"
    echo "==== Creating repo $name"
    pachctl create-repo "$name"
    (cd "$name"; find . -type f | pachctl put-file "$name" master -i- -c)
}

create-repo population
create-repo latlon
