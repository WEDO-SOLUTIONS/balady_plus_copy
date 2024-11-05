class ApiUrls {
  static String get _proxy => "smart-advisor-services";

  static String addetionalActivites(String id) =>
      "v1/$_proxy/commercial/homogenous-activity/$id";

  static String permitsForActivites = "v1/$_proxy/commercial/permits-activity";

  static String detailsRegulations(int activityId) =>
      "v1/$_proxy/commercial/activities/$activityId/regulations";

  static String entityActivityDetails =
      "v1/$_proxy/commercial/entity-activity-details";

  static String getSectors = "v1/$_proxy/commercial/lookups/sectors";
  static String getcategories(int id) =>
      "v1/$_proxy/commercial/lookups/sectors/$id/categories";

  static String getrubrics(int id) =>
      "v1/$_proxy/commercial/lookups/categories/$id/rubrics";

  static String getIsics(int id) => "v1/$_proxy/commercial/rubrics";
  static String getActivites(int id) =>
      "v1/$_proxy/commercial/isics/$id/activities";

  static String calculateFees = "v1/$_proxy/commercial/calculator/calculate";

  static String getZones(int activityId) =>
      "v1/$_proxy/gis/actvities/$activityId/restriced-zones";
  static String validatePoint = "v1/$_proxy/commercial/prohibitive-zones";
  static String gisInfo = "v1/$_proxy/gis/location";

  static String search = "v1/smart-advisor-services/commercial/isics/search";

  static String getQR(String id) =>
      "v1/smart-advisor-services/commercial/license-details/$id/qr";
  static String getViolationEntityActivity(int activityId) =>
      "v1/$_proxy/cis/activities/$activityId/entity-details";

  static String getViolationEntityActivityDetails(int activityId) =>
      "v1/$_proxy/cis/activities/$activityId/violation-details";

  static String getViolationDetailsVD(int activityId) =>
      "v1/$_proxy/cis/activities/$activityId/vd/violation-details";
  static String getMapLayers = "v1/gis-urbi-services/layers";

  static String getCities() => "v1/$_proxy/cities";

  static String getDistricts(int cityId) => "v1/$_proxy/districts/$cityId";

  static String getWorkFlow = "v1/$_proxy/commercial/work-flows";

  static String selfRatingItems(int activityId) =>
      "v1/cis-selfrating-services/acitivities/${activityId}/inspection-clauses";

  static String submitRatingItems = "v1/cis-selfrating-services/evaluation";
}
