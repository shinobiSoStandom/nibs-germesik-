#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/../NotchBuddy"
if [ ! -d ../.nibs-build/dependencies/FluidAudio ]; then
  GIT_TERMINAL_PROMPT=0 git -c credential.helper= clone --depth 1 --branch v0.17.7 https://github.com/FluidInference/FluidAudio ../.nibs-build/dependencies/FluidAudio
fi
test "$(git -C ../.nibs-build/dependencies/FluidAudio rev-parse HEAD)" = "503b4bd1bbf7220882de39fe8ae6716aae4132da" || {
  echo "Unexpected FluidAudio revision; expected the pinned v0.17.7 commit." >&2
  exit 1
}
xcodegen generate --spec nibs-project.yml
GIT_TERMINAL_PROMPT=0 GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=credential.helper GIT_CONFIG_VALUE_0= xcodebuild -packageAuthorizationProvider netrc -scmProvider system -project NIBSGermesik.xcodeproj -scheme NIBSGermesik -configuration Debug -derivedDataPath ../.nibs-build build CODE_SIGNING_ALLOWED=NO
