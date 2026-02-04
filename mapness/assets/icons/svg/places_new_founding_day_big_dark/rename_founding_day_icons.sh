#!/bin/bash
set -e

r () {
  if [ -f "$1" ]; then
    echo "rename $1 -> $2"
    mv "$1" "$2"
  else
    echo "skip $1"
  fi
}

# 1 row
r "MarkerContainer.svg"      "ic_mosques.svg"
r "MarkerContainer(1).svg"   "ic_beauty.svg"
r "MarkerContainer(2).svg"   "ic_gym.svg"
r "MarkerContainer(3).svg"   "ic_markets.svg"
r "MarkerContainer(4).svg"   "ic_recreation.svg"
r "MarkerContainer(5).svg"   "ic_barbershop.svg"
r "MarkerContainer(6).svg"   "ic_car_services.svg"
r "MarkerContainer(7).svg"   "ic_hospital.svg"
r "MarkerContainer(8).svg"   "ic_medicine_ltr.svg"
r "MarkerContainer(9).svg"   "ic_qibla.svg"

# 2 row
r "MarkerContainer(10).svg"  "ic_beach.svg"
r "MarkerContainer(11).svg"  "ic_hotels.svg"
r "MarkerContainer(12).svg"  "ic_restaurant.svg"
r "MarkerContainer(13).svg"  "ic_wc.svg"
r "MarkerContainer(14).svg"  "ic_events.svg"
r "MarkerContainer(15).svg"  "ic_tooth.svg"
r "MarkerContainer(16).svg"  "ic_shopping.svg"
r "MarkerContainer(17).svg"  "ic_gasstation_ltr.svg"
r "MarkerContainer(18).svg"  "ic_park.svg"
r "MarkerContainer(19).svg"  "ic_school_ltr.svg"

# 3 row
r "MarkerContainer(20).svg"  "ic_municipalities.svg"
r "MarkerContainer(21).svg"  "ic_banks.svg"
r "MarkerContainer(22).svg"  "ic_police_station.svg"
r "MarkerContainer(23).svg"  "ic_airport.svg"
r "MarkerContainer(24).svg"  "ic_railway_transport.svg"
r "MarkerContainer(25).svg"  "ic_city_transport.svg"
r "MarkerContainer(26).svg"  "ic_water_places.svg"
r "MarkerContainer(27).svg"  "ic_animals.svg"
r "MarkerContainer(28).svg"  "ic_art_and_design.svg"
r "MarkerContainer(29).svg"  "ic_building_materials.svg"

# 4 row
r "MarkerContainer(30).svg"  "ic_business.svg"
r "MarkerContainer(31).svg"  "ic_childrens_goods.svg"
r "MarkerContainer(32).svg"  "ic_connection.svg"
r "MarkerContainer(33).svg"  "ic_construction.svg"
r "MarkerContainer(34).svg"  "ic_media.svg"
r "MarkerContainer(35).svg"  "ic_clothing_and_footwear.svg"
r "MarkerContainer(36).svg"  "ic_default.svg"

echo "✅ DONE — mapping now matches screenshot exactly"