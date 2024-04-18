class ParkingLot {
  final ParkingLotFilter filter;

  const ParkingLot({
    this.filter = ParkingLotFilter.all,
  });
}

enum ParkingLotFilter {
  all,
  free,
  paid,
  forTaxi,
  forDisabledPersons,
  forElectricVehicles,
}
