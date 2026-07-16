# UXCam — full event list (stream B)

> **UPDATE 2026-07-14:** UXCam has been removed; the events listed here now go
> through the `BaladyAnalytics` facade (event name = `name`, while
> `group`/`screen`/`action` are structural properties rather than the
> concatenated `group::screen::name`). This document is kept as a catalog of
> events and their call sites.

> Companion to `ANALYTICS_REPORT.md`. All UXCam events were sent through the
> static `Metrics` wrapper (`mapness/lib/shared/lib/urbi_metrics.dart`):
> `Metrics.logEventAdvanced(name, group:, screen:, action:, props:)` and
> `Metrics.logEvent(name, object:, extras:)` → `FlutterUxcam.logEvent[WithProperties]`.

> **Format of the final event string in UXCam:** `group::screen::name => action`
> (for `logEvent` — `object::name`). In the tables below, the **Event** column
> is `name` (already resolved from `MetricsConstants`), and **Tag** is `group`.
> **145** calls total across **82** files.

Tags (`group`) = screen domains from `MetricsConstants`:


## Explore — Landing/Explore tab (navbar, banners, icons, quick filters)  (25)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Bookmark icon | tap | `` | `widgets/landing/map_quick_filters.dart:76` |
| Bookmark icon | tap | `` | `widgets/landing/map_quick_filters.dart:121` |
| Compass | tap | `` | `shared/providers/map/bearing_state.dart:50` |
| Drive back home - Show routes | tap | `` | `widgets/landing/drive_back_home_card.dart:270` |
| Enhance Urban Scene banner button | tap | `` | `widgets/landing/dashboard/dashboard_actions.dart:130` |
| Events Calendar - View all | tap | `` | `widgets/landing/events_home_card_wrapper.dart:30` |
| Events Calendar banner | tap | `` | `widgets/landing/events_home_card_wrapper.dart:28` |
| Layers icon | tap | `` | `widgets/landing/layers_control.dart:21` |
| Locate me icon | tap | `` | `widgets/landing/follow_control.dart:35` |
| Places to visit banner | tap | `` | `widgets/landing/place_preview.dart:62` |
| Places to visit banner | tap | `` | `widgets/landing/place_preview_makkah.dart:143` |
| Prayer Times banner bell icon | tap | `` | `widgets/landing/prayer_card.dart:172` |
| Prayer Times banner button | tap | `` | `widgets/landing/prayer_card.dart:76` |
| Qibla | tap | `` | `entry_point.dart:1160` |
| Qibla | tap | `` | `widgets/landing/dashboard/dashboard_actions.dart:58` |
| Qibla | tap | `` | `widgets/landing/qibla_card.dart:23` |
| Search field | tap | `` | `widgets/landing/dashboard_header.dart:189` |
| Stories - close | tap | `` | `pages/stories/stories_page.dart:99` |
| Story banner | tap | `` | `entry_point.dart:1236` |
| Story banner | tap | `` | `pages/stories/stories_page.dart:109` |
| Story banner | tap | `` | `widgets/stories/lib/stories_widget.dart:51` |
| Traffic light button | tap | `` | `features/lifestyle_layers/providers/layers_controls.dart:915` |
| Traffic light button | tap | `` | `pages/free_roam/ui/traffic_parking_control.dart:161` |
| Traffic light button | tap | `` | `widgets/landing/traffic_control.dart:27` |
| Weather icon | tap | `` | `widgets/weather/weather_control.dart:23` |

## Poi — POI card (actions: route, call, favorites, share, photos)  (22)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Add to favorite | tap | `` | `pages/poi_card/poi_card_wrapper.dart:406` |
| Call | tap | `` | `pages/poi_card/founding_day_card_content.dart:269` |
| Call | tap | `` | `pages/poi_card/poi_card_content.dart:357` |
| Entrances | tap | `` | `features/poi_card/provider/poi_card_actions_provider.dart:113` |
| Exit button | tap | `` | `pages/poi_card/poi_functions.dart:4` |
| Exit button | tap | `` | `pages/poi_makkah/poi_card_content.dart:180` |
| Favorites | tap | `` | `features/poi_card/widgets/poi_content_sliver.dart:176` |
| Make route | tap | `` | `pages/poi_card/poi_card_wrapper.dart:288` |
| Make route | tap | `` | `pages/poi_makkah/poi_card_content_footer.dart:17` |
| Map | tap | `` | `features/map_tap_handler/map_tap_handler_provider.dart:186` |
| Marker | tap | `` | `shared/extensions/markers_from_search.dart:125` |
| My Location | tap | `` | `features/map_tap_handler/map_tap_handler_provider.dart:221` |
| My Location | tap | `` | `widgets/landing/dashboard/dashboard_actions.dart:99` |
| Object | tap | `` | `pages/map_search/ui/map_search_history.dart:55` |
| Object | tap | `` | `pages/navi_search/ui/navi_search_history.dart:55` |
| Photo | tap | `` | `features/poi_card/widgets/photo_row/poi_photo_row_builder.dart:126` |
| Road event | tap | `` | `features/map_tap_handler/map_tap_handler_provider.dart:43` |
| Share | tap | `` | `pages/poi_card/founding_day_card_content.dart:256` |
| Share | tap | `` | `pages/poi_card/poi_card_content.dart:344` |
| Share | tap | `` | `pages/poi_card/poi_card_no_info.dart:48` |
| Tab | tap | `` | `features/poi_card/widgets/poi_tabs.dart:59` |
| Tab | tap | `` | `features/poi_card/widgets/poi_tabs.dart:76` |

## Routes — Routes screen (point search, route selection, specify-on-map)  (21)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Change location | tap | `` | `pages/routing/routing_points.dart:196` |
| Change location | tap | `` | `pages/routing/ui/routing_change_path_sheet.dart:203` |
| Favorite/Back | tap | `` | `pages/routing/routing_favourites.dart:43` |
| On reorder | tap | `` | `pages/routing/routing_points.dart:229` |
| On reorder | tap | `` | `pages/routing/ui/routing_change_path_sheet.dart:159` |
| Route-selection/Back | tap | `` | `pages/routing/routing_routes.dart:294` |
| Route-selection/Change nav type | tap | `` | `pages/routing/ui/routing_history.dart:58` |
| Route-selection/Change nav type | tap | `` | `pages/routing/ui/routing_info.dart:524` |
| Route-selection/Go btn | tap | `` | `pages/routing/ui/routing_info.dart:443` |
| Route-selection/Reverse Route Direction icon | tap | `` | `pages/routing/routing_routes.dart:240` |
| Search/Back btn | tap | `` | `pages/routing/ui/routing_search_bar.dart:181` |
| Search/Clear search btn | tap | `` | `pages/routing/ui/routing_history.dart:40` |
| Search/Element from the Result list | tap | `` | `pages/routing/ui/routing_search_results.dart:92` |
| Search/History item | tap | `` | `pages/stories/stories_page.dart:117` |
| Search/On delete | tap | `` | `pages/routing/ui/routing_history.dart:48` |
| Search/Submit | type | `` | `pages/routing/ui/routing_search_bar.dart:117` |
| Search/Submit | type | `` | `pages/routing/ui/routing_search_bar.dart:133` |
| Search/Suggestion from the list | tap | `` | `pages/routing/ui/routing_suggest_list.dart:51` |
| Specify on map/Done | tap | `` | `pages/routing/routing_map_select.dart:169` |
| Specify on map/Exit | tap | `` | `pages/routing/routing_map_select.dart:194` |
| Start route from favorite | tap | `` | `pages/routing/routing_points.dart:243` |

## Search — Search (suggest/results, timings)  (12)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Exit icon | tap | `` | `pages/map_search/map_search_sheet.dart:442` |
| Exit icon | tap | `` | `pages/navi_search/navi_bottom_sheet.dart:278` |
| Search field | metrics.type | `` | `pages/map_search/ui/map_search_bar.dart:286` |
| Search field | metrics.type | `` | `pages/map_search/ui/map_search_bar.dart:314` |
| Search in this area | tap | `` | `pages/map_search/ui/map_search_controls.dart:49` |
| Search in this area | tap | `` | `pages/navi_search/ui/navi_search_controls.dart:54` |
| Search result | tap | `` | `pages/map_search/ui/map_search_results.dart:137` |
| Search result | tap | `` | `pages/navi_search/ui/navi_search_results.dart:128` |
| Suggestion | tap | `` | `pages/map_search/ui/map_suggest_list.dart:42` |
| Suggestion | tap | `` | `pages/navi_search/ui/navi_suggest_list.dart:37` |
| Suggestion | tap | `` | `widgets/favourites/search/favourites_search_history.dart:75` |
| Suggestion | tap | `` | `widgets/favourites/search/favourites_suggest_list.dart:43` |

## Navigation — Active navigation (sound, theme, trip completion)  (5)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| End trip and build another | tap | `` | `pages/path_nav/path_nav_page.dart:676` |
| End trip and show home | tap | `` | `features/free_roam/free_roam_manager.dart:71` |
| End trip and show home | tap | `` | `pages/path_nav/path_nav_page.dart:693` |
| End trip and show home | tap | `` | `pages/path_nav/path_nav_page.dart:722` |
| Show route | tap | `` | `pages/path_nav/path_nav_page.dart:819` |

## Layers — Map layers + Compliance  (6)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Compliance/open_create_compliance | tap | `` | `widgets/landing/compliance_card.dart:16` |
| Exit icon | tap | `` | `pages/free_roam/ui/road_panel_sheet.dart:67` |
| Exit icon | tap | `` | `widgets/lifestyle_layers/bus/bus_details_content.dart:44` |
| Exit icon | tap | `` | `widgets/lifestyle_layers/layers_sheet_content.dart:43` |
| Exit icon | tap | `` | `widgets/lifestyle_layers/parking_details_content.dart:37` |
| Layer select | tap | `` | `features/lifestyle_layers/providers/layers_controls.dart:376` |

## Login — Login screen  (1)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Sign-in | tap | `` | `shared/lib/auth/auth_methods.dart:83` |

## Favorite — Favorites (add/remove)  (2)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Add items |  | `` | `features/favourites/providers/favourite_cache.dart:357` |
| Delete items |  | `` | `features/favourites/providers/favourite_cache.dart:344` |

## Themes — Special themes (Makkah/Ramadan/Hajj/Foundation/National Day)  (20)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Config asset fallback |  | `` | `features/special_themes/core/places_activation_config.dart:368` |
| Config cache used |  | `` | `features/special_themes/core/places_activation_config.dart:342` |
| Config fetch failed |  | `` | `features/special_themes/core/places_activation_config.dart:287` |
| Config fetch failed |  | `` | `features/special_themes/core/places_activation_config.dart:298` |
| Config fetch failed |  | `` | `features/special_themes/core/places_activation_config.dart:377` |
| Config fetch started |  | `` | `features/special_themes/core/places_activation_config.dart:252` |
| Config fetch success |  | `` | `features/special_themes/core/places_activation_config.dart:277` |
| Debug config refreshed |  | `` | `widgets/debug_overlay/special_theme_debug_panel.dart:800` |
| Debug location refreshed |  | `` | `widgets/debug_overlay/special_theme_debug_panel.dart:504` |
| Debug override enabled |  | `` | `widgets/debug_overlay/special_theme_debug_panel.dart:398` |
| Debug splash triggered |  | `` | `widgets/debug_overlay/special_theme_debug_panel.dart:688` |
| Header icon tapped | tap | `` | `widgets/landing/dashboard/special_theme_header.dart:260` |
| Header icon tapped | tap | `` | `widgets/landing/dashboard/special_theme_header.dart:348` |
| Quick action tapped | tap | `` | `widgets/landing/dashboard/dashboard_actions.dart:35` |
| Splash auto skipped |  | `` | `app/auto_route/guards/theme_splash_guard.dart:42` |
| Splash closed | tap | `` | `pages/theme_splash/theme_splash_page.dart:61` |
| Splash shown |  | `` | `pages/theme_splash/theme_splash_page.dart:52` |
| Splash skipped |  | `` | `app/auto_route/guards/theme_splash_guard.dart:80` |
| Theme activated |  | `` | `entry_point.dart:557` |
| Theme deactivated |  | `` | `entry_point.dart:548` |

## KaabaTour — Kaaba virtual tour  (6)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Card tapped | tap | `` | `widgets/landing/dashboard_contents/base_dashboard_content.dart:100` |
| Card tapped | tap | `` | `widgets/landing/dashboard_contents/makkah_based_dashboard_content.dart:87` |
| Page closed |  | `` | `pages/gaussian_splatting/gaussian_splatting_page.dart:100` |
| Page load completed |  | `` | `pages/gaussian_splatting/gaussian_splatting_page.dart:58` |
| Page load failed |  | `` | `pages/gaussian_splatting/gaussian_splatting_page.dart:83` |
| Page opened |  | `` | `pages/gaussian_splatting/gaussian_splatting_page.dart:45` |

## MakkahPlaces — Makkah Places feature  (11)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| Map camera animated |  | `` | `features/makkah_places/makkah_places_layer_provider.dart:192` |
| Map marker tapped | tap | `` | `features/makkah_places/makkah_places_layer_provider.dart:126` |
| Place POI closed |  | `` | `pages/poi_makkah/poi_card_content.dart:187` |
| Place POI opened |  | `` | `pages/poi_makkah/poi_card_content.dart:94` |
| Place call | tap | `` | `pages/poi_makkah/poi_card_content_footer.dart:76` |
| Place card tapped | tap | `` | `widgets/landing/place_preview_makkah.dart:151` |
| Place directions | tap | `` | `pages/poi_makkah/poi_card_content_footer.dart:25` |
| Place favorite | tap | `` | `pages/poi_makkah/poi_card_content_footer.dart:116` |
| Place share | tap | `` | `pages/poi_makkah/poi_card_content_footer.dart:212` |
| Places load failed |  | `` | `features/makkah_places/makkah_places_repository.dart:32` |
| Places loaded |  | `` | `features/makkah_places/makkah_places_repository.dart:23` |

## AppIconQuickActions — App icon shortcuts  (1)

| Event (`name`) | action | screen | Where (`file:line`) |
|---|---|---|---|
| App icon quick action handled | tap | `` | `features/app_icon_quick_actions/services/app_icon_quick_action_handler.dart:340` |

## Miscellaneous (`Metrics.logEvent`, `object::name` prefix)  (13)

> These are plain `Metrics.logEvent(name, object: runtimeType)` calls — usually
> a timing/latency wrapper around async operations (often next to `mixpanel?.track`).

| Event (`name`) | Where (`file:line`) |
|---|---|
| Auth/doAuth | `features/sso_auth/data/auth_provider.dart:20` |
| Auth/logOut | `features/sso_auth/data/auth_provider.dart:31` |
| Auth/tokenExpireLogout | `features/sso_auth/data/auth_provider.dart:54` |
| IwishFeedbackEntity/submitFeedback | `features/iwish/providers/iwish_entity.dart:29` |
| Jobs: Calculate distance to job | `features/jobs/providers/job_distance_provider.dart:18` |
| Jobs: Request detail for job | `features/jobs/providers/job_detail_provider.dart:17` |
| Jobs: Request statistic for job | `features/jobs/providers/jobs_statistic_provider.dart:18` |
| Profile_Image_Upload | `features/profile/profile_image_provider.dart:100` |
| Search/searchByQuery | `features/search/providers/search.dart:566` |
| SearchQuery | `features/search/providers/search.dart:237` |
| fetchSuggest | `features/search/providers/search.dart:322` |
| quickSearch | `features/search/providers/search.dart:420` |
| searchByText | `features/search/providers/search.dart:484` |

---

**Total: 145 calls** (145 parsed). Additionally, outside the tables:
- `Metrics.logException(ex, stack)` → `FlutterUxcam.reportExceptionEvent` — exception reporting (1 call site, `urbi_metrics.dart`, invoked from code).
- `CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Open_From_Home_Event)` — `entry_point.dart:1188` (direct event, enum outside `mapness/lib`).
- Screen tagging: `FlutterUxcam.tagScreenName(path)` in `routes_observer.dart` — on every push/tab change.
