add-bool-property name default_value:
    #!/bin/bash
    unzip assets/maps/styles/styles.2gis -d assets/maps/styles/_styles
    rm assets/maps/styles/styles.2gis
    printf "\n{{ name }} bool {{ default_value }}" >> assets/maps/styles/_styles/zmap/vidoc/zss/zss_props.list
    temp=$(jq ".properties.{{ name }} = { \"type\": \"bool\", \"default_value\": \"{{ default_value }}\" }" assets/maps/styles/_styles/zmap/vidoc/zss/properties.json)
    temp=$(jq ".v2properties.{{ name }} = { \"type\": \"bool\", \"default_value\": \"{{ default_value }}\" }" <<< $temp)
    echo $temp > assets/maps/styles/_styles/zmap/vidoc/zss/properties.json
    cd assets/maps/styles/_styles
    zip -r ../styles.2gis .
    cd ..
    rm -rf _styles

fix-mapstyles: (add-bool-property "parking_filter_paid_on" "false") (add-bool-property "parking_filter_free_on" "false") (add-bool-property "camerasOn" "false")
