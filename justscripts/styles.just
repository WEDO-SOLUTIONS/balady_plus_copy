add-bool-property name default_value:
    #!/bin/bash
    unzip -o assets/maps/styles/_common-styles.2gis -d assets/maps/styles/_common-styles
    echo "\n{{ name }} bool {{ default_value }}" >> assets/maps/styles/_common-styles/zmap/vidoc/zss/zss_props.list
    temp=$(jq ".properties.$2 = { \"type\": \"bool\", \"default_value\": \"$4\" }" assets/maps/styles/_common-styles/zmap/vidoc/zss/properties.json)
    temp=$(jq ".v2properties.$2 = { \"type\": \"bool\", \"default_value\": \"$4\" }" <<< $temp)
    echo $temp > assets/maps/styles/_common-styles/zmap/vidoc/zss/properties.json
    cd assets/maps/styles/_common-styles
    zip -r ../_common-styles.2gis .
    cd ..
    rm -rf _common-styles

fix-parking: (add-bool-property "parking_filter_paid_on" "false") (add-bool-property "parking_filter_free_on" "false")
