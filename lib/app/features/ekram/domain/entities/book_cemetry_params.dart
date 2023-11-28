class BookCemetryParamas { 


int burialCityId; 
String burialDate; 
int burialTimeId; 
String burialTimeOther; 
int cemeteryId; 
int cemeterySizeId; 
int cemeteryTypeId; 
String deceasedBirthDate; 
String deceasedIdentityNumber; 
int deceasedIdentityTypeId; 
bool isPandemicDeath; 
String? relationship; 
int religionId; 


BookCemetryParamas({
  
  required this.burialCityId,
 required this.burialDate, 
 required this.burialTimeId, 
 required this.burialTimeOther, 
 required this.cemeteryId, 
 required this.cemeterySizeId, 
 required this.cemeteryTypeId, 
 required this.deceasedBirthDate, 
 required this.deceasedIdentityNumber, 
 required this.deceasedIdentityTypeId, 
 required this.isPandemicDeath, 
 this.relationship, 
 required this.religionId, 
 });


    Map<String, dynamic> toMap() => {
        "burialCityId": burialCityId, 
        "burialDate":burialDate, 
        "burialTimeId": burialTimeId, 
        "burialTimeOther":burialTimeOther, 
        "cemeteryId": cemeteryId, 
        "cemeterySizeId":cemeterySizeId, 
        "cemeteryTypeId": cemeteryTypeId, 
        "deceasedBirthDate":deceasedBirthDate, 
        "deceasedIdentityNumber": deceasedIdentityNumber, 
        "deceasedIdentityTypeId":deceasedIdentityTypeId, 
        "isPandemicDeath":isPandemicDeath, 
if (relationship!=null) 
"relationship":relationship, 
"religionId":religionId
      };


}