#!/bin/bash

set -u
set -o  errexit

PWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$PWD/set_mc_root_dir.inc.sh"

cd "$MC_ROOT_DIR"

echo "starting non-carton-based modules install "
./install/install_modules_outside_of_carton.sh
echo "starting carton-based modules install "
./install/install_modules_with_carton.sh
echo "Install complete"
