# Paths
ARCHIVE_PATH := "../assets/maps/styles/styles.2gis"
OLD_ARCHIVE_PATH := "../assets/maps/styles/old_styles.2gis"
UNPACKED_PATH := "../assets/maps/styles/content"
FONTS_SRC_PATH := "../assets/maps/styles/fonts"
FONTS_DEST_PATH := UNPACKED_PATH + "/zmap/vidoc/fonts"
FONT_SET_JSON := FONTS_DEST_PATH + "/font_set.json"

# Check required tools
check_jq:
	#!/bin/bash
	set -euo pipefail
	if ! command -v jq >/dev/null 2>&1; then
		echo "jq is required for styles_prepare.just but is not installed."
		echo "Install jq and rerun the script."
		exit 1
	fi

# Unpack styles.2gis archive
unpack:
	#!/bin/bash
	set -euo pipefail
	if [ ! -f "{{ARCHIVE_PATH}}" ]; then
		echo "Archive {{ARCHIVE_PATH}} not found!"
		exit 1
	fi
	rm -rf "{{UNPACKED_PATH}}"
	mkdir -p "{{UNPACKED_PATH}}"
	echo "Unpacking {{ARCHIVE_PATH}} to {{UNPACKED_PATH}}..."
	unzip -o "{{ARCHIVE_PATH}}" -d "{{UNPACKED_PATH}}"
	echo "Archive unpacked."

# Copy new fonts
copy_fonts:
	#!/bin/bash
	set -euo pipefail
	echo "Copying new fonts to {{FONTS_DEST_PATH}}..."
	mkdir -p "{{FONTS_DEST_PATH}}"
	cp "{{FONTS_SRC_PATH}}/FrutigerLTArabic65Bold.ttf" "{{FONTS_DEST_PATH}}/"
	cp "{{FONTS_SRC_PATH}}/GolosText-SemiBold.otf" "{{FONTS_DEST_PATH}}/"
	echo "Fonts copied."

# Update font_set.json
update_font_set:
	#!/bin/bash
	set -euo pipefail
	if ! command -v jq >/dev/null 2>&1; then
		echo "jq is required for styles_prepare.just but is not installed."
		echo "Install jq and rerun the script."
		exit 1
	fi
	echo "Updating {{FONT_SET_JSON}}..."
	mkdir -p "{{FONTS_DEST_PATH}}"
	if [ ! -s "{{FONT_SET_JSON}}" ]; then
		echo '{"fonts":[]}' > "{{FONT_SET_JSON}}"
	fi
	jq '
		.fonts = (.fonts // []) |
		if any(.fonts[]?; .alias == "FrutigerLTArabic65Bold") then . else
			.fonts += [
				{
					"alias": "FrutigerLTArabic65Bold",
					"file_group": ["FrutigerLTArabic65Bold.ttf"]
				}
			]
		end |
		if any(.fonts[]?; .alias == "GolosText_SemiBold") then . else
			.fonts += [
				{
					"alias": "GolosText_SemiBold",
					"file_group": ["GolosText-SemiBold.otf"]
				}
			]
		end
	' "{{FONT_SET_JSON}}" > "{{FONT_SET_JSON}}.tmp"
	mv "{{FONT_SET_JSON}}.tmp" "{{FONT_SET_JSON}}"
	echo "font_set.json updated."

# Patch style-global `dissappear3D` so satellite layer can hide immersive 3D buildings (BALADY-3742).
# Idempotent: re-running the recipe is a no-op once the patches are in place.
patch_dissappear3d:
	#!/bin/bash
	set -euo pipefail
	PROPS="{{UNPACKED_PATH}}/zmap/vidoc/zss/zss_props.list"
	ZSS="{{UNPACKED_PATH}}/zmap/vidoc/zss/styles.zss"
	if [ ! -f "$PROPS" ] || [ ! -f "$ZSS" ]; then
		echo "ZSS sources not found under {{UNPACKED_PATH}}/zmap/vidoc/zss"
		echo "Run 'just unpack' first."
		exit 1
	fi
	echo "Patching dissappear3D declaration in $PROPS..."
	if ! grep -qE '^dissappear3D[[:space:]]' "$PROPS"; then
		echo "dissappear3D bool false" >> "$PROPS"
		echo "  + declaration added"
	else
		echo "  = declaration already present, skipped"
	fi
	echo "Patching immersive 3D sublayer guards in $ZSS..."
	BEFORE=$(grep -cE '\[dissappear3D = false\]\[db_sublayer = Immersive_model' "$ZSS" || true)
	sed -i.bak -E '/\[dissappear3D = false\]/!s/^([[:space:]]*)\[db_sublayer = (Immersive_model[a-zA-Z_]*)\] \{$/\1[dissappear3D = false][db_sublayer = \2] {/' "$ZSS"
	rm -f "$ZSS.bak"
	AFTER=$(grep -cE '\[dissappear3D = false\]\[db_sublayer = Immersive_model' "$ZSS" || true)
	if [ "$BEFORE" -eq "$AFTER" ]; then
		echo "  = $AFTER immersive blocks already guarded, no change"
	else
		echo "  + guarded immersive blocks: $BEFORE -> $AFTER"
	fi

# Pack styles_unpack back to styles.2gis
pack:
	#!/bin/bash
	set -euo pipefail
	echo "Packing {{UNPACKED_PATH}} back into {{ARCHIVE_PATH}}..."
	if [ ! -d "{{UNPACKED_PATH}}" ]; then
		echo "Unpacked content {{UNPACKED_PATH}} not found!"
		exit 1
	fi
	if [ ! -f "{{ARCHIVE_PATH}}" ]; then
		echo "Archive {{ARCHIVE_PATH}} not found!"
		exit 1
	fi
	echo "Renaming existing archive to {{OLD_ARCHIVE_PATH}}..."
	mv -f "{{ARCHIVE_PATH}}" "{{OLD_ARCHIVE_PATH}}"
	cd "{{UNPACKED_PATH}}"
	zip -r ../styles.2gis .
	cd - >/dev/null
	echo "Archive updated."

# Prepare styles before commit
style_prepare: check_jq unpack copy_fonts update_font_set patch_dissappear3d pack
