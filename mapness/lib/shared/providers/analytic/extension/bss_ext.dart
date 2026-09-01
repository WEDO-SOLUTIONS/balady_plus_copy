import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_contacts.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/directory_obj_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';

extension BssTracking on BssService {
  Future<void> trackFavoriteTap(DirectoryObjectMessage data) => sendEvent(
    BssRequest(
      eventType: BSSEventType.action,
      actionType: BSSActionType.tap,
      uiElement: const BssUIElement(
        name: BssUIElementNames.bookmark,
        ownerName: BssUIElementNames.placeCardMini,
      ),
      payload: BssPayload(
        placeItem: data.toBss(1),
      ),
    ),
  );

  Future<void> trackCallTap(DirectoryObjectMessage data, String phoneNumber) => sendEvent(
    BssRequest(
      eventType: BSSEventType.action,
      actionType: BSSActionType.tap,
      uiElement: const BssUIElement(
        name: BssUIElementNames.contact,
        ownerName: BssUIElementNames.placeCardMini,
      ),
      payload: BssPayload(
        placeItem: data.toBss(2),
        contact: BssContact(type: BssContactType.phone, value: phoneNumber),
      ),
    ),
  );

  Future<void> trackRouteTap(DirectoryObjectMessage data) => sendEvent(
    BssRequest(
      eventType: BSSEventType.action,
      actionType: BSSActionType.tap,
      uiElement: const BssUIElement(
        name: BssUIElementNames.buildRoute,
        ownerName: BssUIElementNames.placeCardMini,
      ),
      payload: BssPayload(
        placeItem: data.toBss(0),
      ),
    ),
  );

  Future<void> trackLinkTap(DirectoryObjectMessage data, BssContactType type, String link) => sendEvent(
    BssRequest(
      eventType: BSSEventType.action,
      actionType: BSSActionType.tap,
      uiElement: const BssUIElement(
        name: BssUIElementNames.contact,
        ownerName: BssUIElementNames.placeCardMini,
      ),
      payload: BssPayload(
        placeItem: data.toBss(3),
        contact: BssContact(type: type, value: link),
      ),
    ),
  );
}

extension BssContactTypeExt on PoiContentSocialMediaTypes {
  BssContactType toBss() => switch (this) {
    PoiContentSocialMediaTypes.website => BssContactType.website,
    PoiContentSocialMediaTypes.instagram => BssContactType.instagram,
    PoiContentSocialMediaTypes.facebook => BssContactType.facebook,
    PoiContentSocialMediaTypes.youtube => BssContactType.youtube,
    PoiContentSocialMediaTypes.linkedin => BssContactType.linkedin,
    PoiContentSocialMediaTypes.whatsapp => BssContactType.whatsapp,
    PoiContentSocialMediaTypes.telegram => BssContactType.telegram,
    PoiContentSocialMediaTypes.twitter => BssContactType.twitter,
    PoiContentSocialMediaTypes.tiktok => BssContactType.website,
  };
}
