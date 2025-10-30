
class EndpointsClassificationCertificate {


  static String searchEndPoints = "v1/ccs-superapp-services/establishments/search";
  static String getEstablishmentsDetails(String serialNumber) => "v1/ccs-superapp-services/establishments/$serialNumber";

  static String getLookups = "v1/ccs-superapp-services/lookups";
  static String getActivities(int sector) => "v1/ccs-superapp-services/sectors/$sector/activities";



}