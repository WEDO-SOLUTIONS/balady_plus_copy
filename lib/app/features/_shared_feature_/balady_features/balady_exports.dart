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
