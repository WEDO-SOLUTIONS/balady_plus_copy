#!/bin/bash

set -euo pipefail

# Script to fix Syncfusion PDF Viewer Registrar compatibility issue with Flutter 3.29.1+
# This patches the deprecated registerWith method that uses PluginRegistry.Registrar

# Resolve the actual pub cache directory that the current Flutter SDK is using
PUB_CACHE_DIR="$(fvm flutter pub cache 2>/dev/null | awk 'END {print $NF}')"
PLUGIN_FILE="$PUB_CACHE_DIR/hosted/pub.dev/syncfusion_flutter_pdfviewer-26.2.14/android/src/main/java/com/syncfusion/flutter/pdfviewer/SyncfusionFlutterPdfViewerPlugin.java"

if [ ! -f "$PLUGIN_FILE" ]; then
    echo "⚠ Syncfusion plugin file not found (this is OK if package isn't installed yet)"
    exit 0
fi

# Check if already patched
if grep -q "Removed registerWith method" "$PLUGIN_FILE"; then
    echo "✓ Syncfusion plugin already patched"
    exit 0
fi

# Create backup
cp "$PLUGIN_FILE" "$PLUGIN_FILE.backup" 2>/dev/null || true

# Use sed to comment out the registerWith method (lines 75-79)
# Note: Must comment out all lines including the closing brace
sed -i.backup2 \
    -e '75s|^  @SuppressWarnings("deprecation")|  // Removed registerWith method - uses deprecated PluginRegistry.Registrar not available in Flutter 3.29.1+\n  // Plugin uses FlutterPlugin interface (onAttachedToEngine) instead\n  // @SuppressWarnings("deprecation")|' \
    -e '76s|^  public static void registerWith|  // public static void registerWith|' \
    -e '77s|^    final MethodChannel channel|    //   final MethodChannel channel|' \
    -e '78s|^    channel.setMethodCallHandler|    //   channel.setMethodCallHandler|' \
    -e '79s|^  }$|  // }|' \
    "$PLUGIN_FILE" 2>/dev/null

# Fix any uncommented closing brace that might have been missed
sed -i.backup3 -e '/^  }$/{
    N
    /^  }\n$/{
        s|^  }|  // }|
    }
}' "$PLUGIN_FILE" 2>/dev/null || true

# Verify the patch was applied
if grep -q "Removed registerWith method" "$PLUGIN_FILE"; then
    echo "✓ Successfully patched Syncfusion PDF Viewer plugin"
    rm -f "$PLUGIN_FILE.backup2" 2>/dev/null || true
else
    echo "⚠ Failed to patch plugin automatically. The plugin may need manual patching."
    # Don't exit with error - let the build try anyway
fi
