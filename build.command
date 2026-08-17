#!/bin/bash
#
# build.command
# QuickMockup
#
# Builds QuickMockup.app from the command line via xcodebuild — no Xcode
# GUI required, just the Xcode Command Line Tools.
#
# Usage:
#   ./build.command             # Release build, opens the .app when done
#   ./build.command debug       # Debug build
#   ./build.command --no-open   # Don't reveal/open the built app afterwards
#
# Double-clicking this file in Finder also works (Terminal.app runs it).

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

PROJECT="QuickMockup.xcodeproj"
SCHEME="QuickMockup"
CONFIGURATION="Release"
OPEN_AFTER_BUILD=1
BUILD_DIR="$(pwd)/build"

for arg in "$@"; do
    case "$arg" in
        debug|Debug)
            CONFIGURATION="Debug"
            ;;
        release|Release)
            CONFIGURATION="Release"
            ;;
        --no-open)
            OPEN_AFTER_BUILD=0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            echo "Usage: $0 [debug|release] [--no-open]" >&2
            exit 1
            ;;
    esac
done

if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "error: xcodebuild not found." >&2
    echo "Install the Xcode Command Line Tools with: xcode-select --install" >&2
    exit 1
fi

echo "Building QuickMockup (${CONFIGURATION})…"

LOG_FILE="$(pwd)/build.log"

set +e
xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$BUILD_DIR" \
    CODE_SIGNING_ALLOWED=NO \
    build 2>&1 | tee "$LOG_FILE"
BUILD_STATUS="${PIPESTATUS[0]}"
set -e

if [ "$BUILD_STATUS" -ne 0 ]; then
    echo ""
    echo "error: build failed. Relevant errors from $LOG_FILE:"
    echo "----------------------------------------------------"
    grep -E "error:|Compilation failed|BUILD FAILED" "$LOG_FILE" || echo "(no 'error:' lines found — see $LOG_FILE for the full log)"
    echo "----------------------------------------------------"
    exit "$BUILD_STATUS"
fi

APP_PATH="$BUILD_DIR/Build/Products/$CONFIGURATION/QuickMockup.app"

if [ ! -d "$APP_PATH" ]; then
    echo "error: build finished but app not found at $APP_PATH" >&2
    exit 1
fi

echo ""
echo "Build succeeded: $APP_PATH"

if [ "$OPEN_AFTER_BUILD" -eq 1 ]; then
    open -R "$APP_PATH"
    read -r -p "Launch QuickMockup now? [Y/n] " answer
    case "$answer" in
        [nN]*) ;;
        *) open "$APP_PATH" ;;
    esac
fi
