#!/usr/bin/env bash

set -eo pipefail

if [[ "$SKIP_BUNDLING" ]]; then
  echo "SKIP_BUNDLING enabled; skipping create-manifest-ios.sh."
  exit 0;
elif [[ "$CONFIGURATION" == *Debug* ]]; then
  if [[ "$FORCE_BUNDLING" ]]; then
    echo "FORCE_BUNDLING enabled; continuing create-manifest-ios.sh."
  else
    exit 0;
  fi
fi

DEST="$CONFIGURATION_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH"
ENTRY_FILE=${ENTRY_FILE:-index.js}
RCT_METRO_PORT=${RCT_METRO_PORT:=8081}
NODE_BINARY=${NODE_BINARY:-node}

# Related to: https://github.com/facebook/react-native/blob/c9f869f9c7c8b035a669980382af4bbd4afecb89/scripts/react-native-xcode.sh#L59-L69
PROJECT_ROOT=${PROJECT_ROOT:-$PWD}
cd "$PROJECT_ROOT" || exit

if ! [ -x "$(command -v "$NODE_BINARY")" ]; then
  echo 'Error: cannot find the node binary. Try setting the NODE_BINARY variable in the ' \
  '"Bundle React Native code and images" Build Phase to the absolute path to your node binary. ' \
  'You can find it by executing "which node" in a terminal window.' >&2
  exit 1
fi

"$NODE_BINARY" "$(dirname "${BASH_SOURCE[0]}")/createManifest.js" ios "$PROJECT_ROOT" "$DEST"
