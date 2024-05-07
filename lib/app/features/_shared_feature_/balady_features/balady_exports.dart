/** This Document is to provide the exports that Urbi will used inside Balady App */

// Event Model
export '../../events/domain/entities/search_events/search_events_item.dart';

//! Home Cards

// Prayers Card
export 'widgets/home/pary_card/prayer_home_card.dart';

// Usage
//? PrayerHomeCard()

// Calendar Home Card
export 'widgets/home/calendar_card/calendar_home_item_card.dart';

export 'widgets/home/calendar_card/calendar_home_card.dart';

// Usage
//? CalendarHomeCard()

// Events Home Card
export 'widgets/home/events_card/events_item_card.dart';

export 'widgets/home/events_card/events_home_card.dart';

// Usage
//? EventsHomeCard()

//! GIS Layers Cards
// Opportunity Card (Opportunities Layer)
export 'widgets/map/oppotunity_card.dart';

// Usage

/**
 //? OpprtunityMapCard()
 
 //? Params
 type = MAIN_ACTIVITY_NAME
 documentValue = DOCUMENTVALUE
 dailyCost = DAILYLEASECOST
 description = OPPORTUNITYDESCRIPTION 
 area = SITEAREA 
 subMunicipality = SUBMUNICIPALITY_ID; 
 bidEndDate = BIDENDDATE; 
 location  = LOCATIONLISTSTRING; 
 mainActivcity = MAIN_ACTIVITY_NAME
 id = ID 
 opprtunityNumber = OPPORTUNITYNUMBER  

onClose : this function is called when press the x on the card. **/

// Compliance Card (BSAimtithalBuildingsCertificateL Layer)

export 'widgets/map/compliance_card.dart';
/**
// Usage
//? ComplainceMapCard()

 //? Params
amana = AMANANAME
stageNo = STAGENO 
targetBuildingType = TARGETBUILDINGTYPE
streetName = STREETNAME
onClose : this function is called when press the x on the card. **/

// WhiteLand Card (BSWhiteParcelS Layer)

export 'widgets/map/white_land_card.dart';
// Usage

/**
//? WhiteLandMapCard()

//? Params
 municipality = MUNNAME
streetName = STREETNAME 
parcelNo = PARCELCODE
stageNo = PHASE
onClose : this function is called when press the x on the card. **/

export 'widgets/map/event_card.dart';

//Usage
/**
 //? EventMapCard
 //? Params 

 SearchEventsItem from BaladyServices.getEvents()



 */

// Layers Calls

//? (Opportunities Layer)
/**
https://apiservicesstg.balady.gov.sa/v1/gis-urbi-services/layers/2/query?outFields=OBJECTID%2CSTATUS%2COPPORTUNITYNUMBER%2CID%2CSITEAREA%2CDAILYLEASECOST%2CSUBMUNICIPALITY_ID%2CDOCUMENTVALUE%2CTYPE%2CBIDENDDATE%2COPPORTUNITYDESCRIPTION%2CSITENUMBER%2CSITEADDRESS%2CMAIN_ACTIVITY_NAME%2CLOCATIONLISTSTRING%2CRFPENDDATE%2CREGION_ID&geometryType=esriGeometryEnvelope&geometry=46.684081591665745%2C24.703509105619972%2C46.75789598375559%2C24.833192973933365&spatialRel=esriSpatialRelIntersects



 *  "OBJECTID",
        "STATUS",
        "OPPORTUNITYNUMBER",
        "ID",
        "SITEAREA",
        "DAILYLEASECOST",
        "SUBMUNICIPALITY_ID",
        "DOCUMENTVALUE",
        "TYPE",
        "BIDENDDATE",
        "OPPORTUNITYDESCRIPTION",
        "SITENUMBER",
        "SITEADDRESS",
        "MAIN_ACTIVITY_NAME",
        "LOCATIONLISTSTRING",
        "RFPENDDATE",
        "REGION_ID"
 */

// ? (BSAimtithalBuildingsCertificateL Layer)
//https://apiservicesstg.balady.gov.sa/v1/gis-urbi-services/layers/7/query?outFields=OBJECTID%2CPRIORITYAREA%2CSTARTDATE%2CTARGETBUILDINGTYPE%2CSTAGENO%2CAMANANAME%2CSTREETNAME%2CMUNICIPALITYNAME%2CDISTRICTNAME%2CSTREETTYPE%2CSTREETWIDTH&geometryType=esriGeometryEnvelope&geometry=46.684081591665745%2C24.703509105619972%2C46.75789598375559%2C24.833192973933365&spatialRel=esriSpatialRelIntersects

/**
 *     "OBJECTID",
        "PRIORITYAREA",
        "STARTDATE",
        "TARGETBUILDINGTYPE",
        "STAGENO",
        "AMANANAME",
        "STREETNAME",
        "MUNICIPALITYNAME",
        "DISTRICTNAME",
        "STREETTYPE",
        "STREETWIDTH"
 */

//? (BSWhiteParcelS Layer)

// https://apiservicesstg.balady.gov.sa/v1/gis-urbi-services/layers/8/query?outFields=OBJECTID%2CAMANANAME%2CMUNNAME%2CPARCELCODE%2CSTATUS%2CSTREETNAME%2CPARCELAREA%2CCITYNAME%2CPARCELNO%2CPARCELLENGTH%2CPHASE&geometryType=esriGeometryEnvelope&geometry=46.684081591665745%2C24.703509105619972%2C46.75789598375559%2C24.833192973933365&spatialRel=esriSpatialRelIntersects

/**
 *   "OBJECTID",
        "AMANANAME",
        "MUNNAME",
        "PARCELCODE",
        "STATUS",
        "STREETNAME",
        "PARCELAREA",
        "CITYNAME",
        "PARCELNO",
        "PARCELLENGTH",
        "PHASE"
 */
