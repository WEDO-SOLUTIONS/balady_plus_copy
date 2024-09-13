add-bool-property name default_value:
    #!/bin/bash
    unzip assets/maps/styles/_common-styles.2gis -d assets/maps/styles/_common-styles
    rm assets/maps/styles/_common-styles.2gis
    printf "\n{{ name }} bool {{ default_value }}" >> assets/maps/styles/_common-styles/zmap/vidoc/zss/zss_props.list
    temp=$(jq ".properties.{{ name }} = { \"type\": \"bool\", \"default_value\": \"{{ default_value }}\" }" assets/maps/styles/_common-styles/zmap/vidoc/zss/properties.json)
    temp=$(jq ".v2properties.{{ name }} = { \"type\": \"bool\", \"default_value\": \"{{ default_value }}\" }" <<< $temp)
    echo $temp > assets/maps/styles/_common-styles/zmap/vidoc/zss/properties.json
    cd assets/maps/styles/_common-styles
    zip -r ../_common-styles.2gis .
    cd ..
    rm -rf _common-styles

fix-parking: (add-bool-property "parking_filter_paid_on" "false") (add-bool-property "parking_filter_free_on" "false")

fix-camerasOn: (add-bool-property "camerasOn" "false")
