#!/bin/bash

# MUST BE RUN ON LINUX TO BUILD CORRECTLY
# Only builds for node version used on x64

node_version="v$(node -p 'process.versions.modules')"

binding_dir="out/Release"

win32_url="https://github.com/node-hid/node-hid/releases/download/v0.7.6/node-hid-v0.7.6-node-$node_version-win32-x64.tar.gz"
darwin_url="https://github.com/node-hid/node-hid/releases/download/v0.7.6/node-hid-v0.7.6-node-$node_version-darwin-x64.tar.gz"

win32_file_name="HID-win32-$node_version.node"
darwin_file_name="HID-darwin-$node_version.node"
linux_file_name="HID-linux-$node_version.node"


if [[ -z $(ls hidapi) ]]; then
  echo 'please initialize and update submodules'
  exit 1
fi

if ! [[ -d "$binding_dir" ]]; then
  echo "> binding dir not found, creating '$binding_dir'"
  mkdir -p "$binding_dir"
fi

set -e

echo "> fetching $darwin_file_name from node-hid/node-hid@0.7.6..."
curl -sL -o "$binding_dir/$darwin_file_name" "$darwin_url"
echo '> done'

echo "> fetching $win32_file_name from node-hid/node-hid@0.7.6..."
curl -sL -o "$binding_dir/$win32_file_name" "$win32_url"
echo '> done'

echo "> compiling $linux_file_name..."
npm install
npx node-gyp rebuild
mv build/Release/HID.node "$binding_dir/$linux_file_name"
echo "> done"
