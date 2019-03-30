#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TMPBUILDDIR="${DIR}/build/tmp"

# Dependencies
if ! [ -x "$(command -v zip)" ]; then
  echo 'Error: zip is not installed, please install and rerun script.' >&2
  exit 1
fi

if ! [ -x "$(command -v xmlstarlet)" ]; then
  echo 'Error: XMLStarlet is not installed, please install and rerun script.' >&2
  echo 'eg. brew install xmlstarlet'
  exit 1
fi

mkdir -p "$TMPBUILDDIR"
cp -R "${DIR}/src/." "$TMPBUILDDIR"

# Copy readme into Alfred workflow
xmlstarlet edit --inplace --update '//key[text()="readme"]/following::string[1]' --value "$(<"${DIR}/README.md")" "$TMPBUILDDIR/info.plist"

# Add version from git tag if available
VERSION="$(git describe --abbrev=0 --tags)"
[ ! -z "${VERSION}" ] && printf "$VERSION" > "$TMPBUILDDIR/version"

# Build
cd "$TMPBUILDDIR"
zip -r "${DIR}/build/Wordpress_Hash.alfredworkflow" .

# Clean up
rm -rf "$TMPBUILDDIR"