class GetCemetriesParams { 


  int burialCityId; 
  String burialDate; 
  int cemeterySizeId; 
  int cemeteryTypeId; 
  bool isPandemicDeath; 
  int nationalityId;
  int religionId; 


  GetCemetriesParams({
required this.burialCityId, 
required this.burialDate, 
required this.cemeterySizeId, 
required this.cemeteryTypeId,
 required this.isPandemicDeath, 
 required this.nationalityId, 
 required this.religionId
   }); 


    Map<String, dynamic> toMap() => {
        "burialCityId": burialCityId, 
        "burialDate":burialDate, 
        "cemeterySizeId":cemeterySizeId, 
        "cemeteryTypeId":cemeteryTypeId, 
        "isPandemicDeath":isPandemicDeath, 
        "nationalityId":nationalityId, 
        "religionId":religionId
      };



}