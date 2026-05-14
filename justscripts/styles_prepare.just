# Paths
ARCHIVE_PATH := "assets/maps/styles/styles.2gis"
UNPACKED_PATH := "assets/maps/styles/content"
FONTS_SRC_PATH := "lib/src/fonts"
FONTS_DEST_PATH := UNPACKED_PATH + "/zmap/vidoc/fonts"
FONT_SET_JSON := FONTS_DEST_PATH + "/font_set.json"

# Unpack styles.2gis archive
unpack:
	#!/bin/bash
	if [ ! -f "{{ARCHIVE_PATH}}" ]; then
		echo "Archive {{ARCHIVE_PATH}} not found!"
		exit 1
	fi
	echo "Unpacking {{ARCHIVE_PATH}} to {{UNPACKED_PATH}}..."
	unzip -o "{{ARCHIVE_PATH}}" -d "{{UNPACKED_PATH}}"
	#rm "{{ARCHIVE_PATH}}"
	echo "Archive unpacked."

# Copy new fonts
copy_fonts:
	#!/bin/bash
	echo "Copying new fonts to {{FONTS_DEST_PATH}}..."
	cp "{{FONTS_SRC_PATH}}/FrutigerLTArabic65Bold.ttf" "{{FONTS_DEST_PATH}}/"
	cp "{{FONTS_SRC_PATH}}/GolosText-SemiBold.otf" "{{FONTS_DEST_PATH}}/"
	echo "Fonts copied."

# Update font_set.json
update_font_set:
	#!/bin/bash
	echo "Updating {{FONT_SET_JSON}}..."
	jq '.fonts += [
		{
			"alias": "FrutigerLTArabic65Bold",
			"file_group": ["FrutigerLTArabic65Bold.ttf"]
		},
		{
			"alias": "GolosText_SemiBold",
			"file_group": ["GolosText-SemiBold.otf"]
		}
	]' "{{FONT_SET_JSON}}" > "{{FONT_SET_JSON}}.tmp"
	mv "{{FONT_SET_JSON}}.tmp" "{{FONT_SET_JSON}}"
	echo "font_set.json updated."

# Pack styles_unpack back to styles.2gis
pack:
	#!/bin/bash
	echo "Packing {{UNPACKED_PATH}} back into {{ARCHIVE_PATH}}..."
	cd "{{UNPACKED_PATH}}"
	zip -r ../styles.2gis .
	cd ..
	pwd
	echo "Archive updated."

# Prepare styles before commit
style_prepare:
	just unpack
	#just copy_fonts
	#just update_font_set
	#just pack
