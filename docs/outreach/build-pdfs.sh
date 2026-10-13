#!/usr/bin/env bash
# Prints fax-pack.html to the two fax PDFs with headless Chrome (or Edge).
# Run from anywhere: bash docs/outreach/build-pdfs.sh
set -e
cd "$(dirname "$0")"

BROWSER="/c/Program Files/Google/Chrome/Application/chrome.exe"
[ -x "$BROWSER" ] || BROWSER="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"

SRC="file:///$(pwd -W 2>/dev/null || pwd)/fax-pack.html"

print() {
  "$BROWSER" --headless=new --disable-gpu --no-pdf-header-footer \
    --virtual-time-budget=3000 --print-to-pdf="$(pwd -W 2>/dev/null || pwd)/$2" "$SRC#$1"
}

print railway   RideTrack-Fax-SriLankaRailways.pdf
print transport RideTrack-Fax-TransportDept.pdf
