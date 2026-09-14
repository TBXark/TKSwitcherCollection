#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v xcodegen >/dev/null 2>&1; then
    echo "error: xcodegen is required (brew install xcodegen)" >&2
    exit 1
fi

cd "$ROOT/Demo"
xcodegen generate
open "$ROOT/Demo/TKSwitcherCollectionDemo.xcodeproj"
