#!/usr/bin/env bash
set -Eeou pipefail

scriptdir=$(dirname -- "$(readlink -f -- "$0")")

swift build -c release -Xswiftc -cross-module-optimization || exit 1

ln -sfv "$scriptdir"/.build/arm64-apple-macosx/release/MacOSUtility "$HOME"/bin/