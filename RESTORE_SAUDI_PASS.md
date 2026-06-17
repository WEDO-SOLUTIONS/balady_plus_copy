# Restoring the Saudi Pass (Tadlal) Feature

This document explains how the **Saudi Pass** feature (internally also called **Tadlal**)
was removed from the codebase, where a full backup lives, and exactly how to bring it
back if the CTO decides to reactivate it.

> **TL;DR**
> - Saudi Pass was removed in a single commit: **`08bae7b7d` – "remove all Saudi Pass files"**.
> - That commit lives in `release/2026_may_2` and (via fast-forward) in `development`.
> - A ready-to-use backup with Saudi Pass restored on top of the latest code lives on the
>   branch **`backup/saudi_pass_feature`**.
> - To restore: merge `backup/saudi_pass_feature`, OR re-run `git revert 08bae7b7d` on the
>   target branch and resolve 2 conflicts (`app_routes.dart`, `profile_page.dart`).

---

## 1. Background

| Item | Value |
|---|---|
| Feature name in code | `saudi_pass` (folders), `Tadlal` / `tadlal` (business name) |
| Removal commit | `08bae7b7d` – *"remove all Saudi Pass files"* |
| Removal branch | `hotfix/remove_tadlal` |
| Last commit **with** Saudi Pass intact (removal's parent) | `16c86ca09` – *"Merged PR 30943: Update Form last reales"* |
| Removal size | **131 files changed, ~72 insertions, ~9031 deletions** |
| Backup branch (latest code **with** Saudi Pass) | `backup/saudi_pass_feature` |

The removal commit touched two kinds of files:

1. **~100 Saudi Pass-owned files** — files living under `saudi_pass/` folders
   (`entities/saudi_pass`, `features/saudi_pass`, `pages/saudi_pass`). These were fully deleted.
2. **~30 shared files** — files like routes, search, favourites, profile, poi_card, dashboard.
   Only their Saudi Pass *references* were stripped out (imports, route entries, list items, etc.).

Restoring the feature means re-adding the owned files **and** re-wiring the references in the
shared files.

---

## 2. The Backup Branch — `backup/saudi_pass_feature`

This branch = **latest release code (`release/2026_may_2`) + Saudi Pass restored**.

It was created by:

```bash
git checkout -b backup/saudi_pass_feature origin/release/2026_may_2
git revert --no-commit 08bae7b7d        # re-adds all Saudi Pass code & wire-ins
# resolve the 2 conflicts (see section 4), then:
git add -A
git commit -m "Restore Saudi Pass (Tadlal) feature on top of latest code"
```

### Keeping the backup up to date

Whenever the release/development line advances, refresh the backup so it always holds
"latest code + Saudi Pass":

```bash
git checkout backup/saudi_pass_feature
git fetch origin
git merge origin/development        # or origin/release/<next_release>
# resolve any conflicts that touch Saudi Pass call-sites, commit
```

---

## 3. How to Restore Saudi Pass into an Active Branch

You have two options.

### Option A — Merge the backup branch (simplest)

```bash
git checkout <target-branch>          # e.g. a new feature/restore_saudi_pass branch
git merge backup/saudi_pass_feature
# resolve conflicts if the target diverged, commit
```

### Option B — Re-apply the inverse of the removal commit

```bash
git checkout <target-branch>
git revert 08bae7b7d
# resolve the 2 conflicts in section 4, then commit
```

Both produce the same result: Saudi Pass files restored and wired back into the app.

---

## 4. The 2 Known Conflicts (and how to resolve them)

Reverting `08bae7b7d` re-adds ~100 files and ~30 wire-ins automatically. Only **2 files
conflict**, because they were changed again *after* the removal:

### 4a. `mapness/lib/app/auto_route/app_routes.dart`

**Why it conflicts:** the `MapRoute` `children:` list was re-indented/restructured on the latest
code after the removal. The revert wants to re-insert the Saudi Pass routes into the old structure.

**How to resolve:** keep the **latest** (HEAD) structure and formatting, and re-insert the
following Saudi Pass route entries into the `MapRoute` `children:` list (at the same nesting
level as the other child routes):

```dart
CustomRoute(
  path: 'saudi_pass_offers_screen',
  page: OffersScreenViewRoute.page,
),
AppRoute(
  path: 'saudi_pass_favourite_offers_screen',
  page: FavouriteOffersScreenViewRoute.page,
),
RedirectRoute(
    path: 'saudi_pass_profile_preferences_screen',
    redirectTo: 'profile_preferences'),
AppRoute(
  path: 'saudi_pass_offers_on_map_screen',
  page: OffersOnMapRoute.page,
),
CustomRoute(
  page: CitySelectionDialogViewRoute.page,
  path: 'saudi_pass_city_selection_dialog',
  opaque: false,
  transitionsBuilder: TransitionsBuilders.slideBottom,
),
CustomRoute(
  path: 'saudi_pass_type_selection_dialog',
  page: TypeSelectionDialogViewRoute.page,
  customRouteBuilder: RouteBuilders.modalSheetBuilder,
),
CustomRoute(
  path: 'saudi_pass_all_categories_selection_dialog',
  page: AllCategoriesSelectionDialogViewRoute.page,
  opaque: false,
  transitionsBuilder: TransitionsBuilders.slideBottom,
),
CustomRoute(
  path: 'saudi_pass_sorting_selection_dialog',
  page: SortingSelectionDialogRoute.page,
  customRouteBuilder: RouteBuilders.modalSheetBuilder,
),
AppRoute(
  path: 'saudi_pass_settings_screen',
  page: SettingsScreenViewRoute.page,
),
CustomRoute(
  path: 'saudi_pass_offer_page',
  page: OfferRoute.page,
),
RedirectRoute(
    path: 'saudi_pass_offer_feedback', redirectTo: 'feedback'),
CustomRoute(
  path: 'saudi_pass_offer_favorites_removing_sheet',
  page: OfferFavoritesRemovingSheetRoute.page,
  customRouteBuilder: RouteBuilders.modalSheetBuilder,
),
AppRoute(
  path: 'profile_preferences',
  page: ProfilePreferencesRoute.page,
),
```

> Tip: get the authoritative version straight from the pre-removal commit:
> ```bash
> git show 16c86ca09:mapness/lib/app/auto_route/app_routes.dart
> ```

### 4b. `mapness/lib/pages/profile/profile_page.dart`

**Why it conflicts:** the surrounding profile layout changed slightly.

**How to resolve:** keep the latest layout, and re-insert the Saudi Pass profile block
(the "Preferences" + "Favorite Offers" rows shown only when `isAuth`):

```dart
if (isAuth)
  Padding(
    padding: const EdgeInsets.only(top: Spacing.$4x),
    child: ContentWrapper(
      color: context.colors.backgroundSurface1,
      children: [
        ContentRowV2(
          isDividerEnabled: true,
          onTap: () => context.router.push(const ProfilePreferencesRoute()),
          trailing: trailing,
          leading: Assets.icons.svg.percent.svg(
            colorFilter: ColorFilter.mode(
              context.colors.accentDefault,
              BlendMode.srcATop,
            ),
          ),
          text: ContentRowTextOptions(title: context.l10n.preferences),
        ),
        ContentRowV2(
          onTap: () => context.router.push(const FavouriteOffersScreenViewRoute()),
          trailing: trailing,
          leading: leadingIconBuilder(GeneralIcons.heart),
          text: ContentRowTextOptions(title: context.l10n.favoriteOffers),
        ),
      ],
    ),
  ),
```

---

## 5. After Restoring — Verification

Saudi Pass code was authored before ~266 newer commits. Symbols it depends on may have been
renamed or moved. Always verify before relying on a restored build:

```bash
cd mapness
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # regenerates auto_route, etc.
flutter analyze
```

Fix any analyzer errors where restored Saudi Pass code references symbols that changed in the
newer codebase (renamed providers, changed widget APIs, moved assets, l10n keys, etc.).

---

## 6. Reference — What Was Removed

### 6a. Saudi Pass-owned files (fully deleted, fully restored by the revert)

Located under:
- `mapness/lib/entities/saudi_pass/`
- `mapness/lib/features/saudi_pass/` (async_iterable, functions, notifiers, pages, providers, repo, riverpods, views, widgets)
- `mapness/lib/pages/saudi_pass/`
- `mapness/lib/widgets/` Saudi Pass widgets (`saudi_pass_chips_widget.dart`, `saudi_pass_city_selection_widget.dart`, `dashboard_offers_row.dart`, …)
- `mapness/test/features/saudi_pass/`

### 6b. Shared files with Saudi Pass references (re-wired by the revert)

Key integration points to sanity-check after restore:
- `mapness/lib/app/auto_route/app_routes.dart` — route registrations (**conflict, see 4a**)
- `mapness/lib/pages/profile/profile_page.dart` — profile menu entries (**conflict, see 4b**)
- `mapness/lib/widgets/scopes/global_scopes.dart` — global providers/scopes
- `mapness/lib/features/search/providers/search.dart`, `search_pagination.dart`, `ui/search_results.dart`
- `mapness/lib/pages/favourites/favourites_page.dart`, `widgets/favourites/favourite_item_widget.dart`, `pinned_place_card.dart`
- `mapness/lib/features/poi_card/...` — `poi_card_provider.dart`, `poi_content_sliver.dart`, `poi_inbuilding_sliver.dart`, `header_info_component.dart`, `poi_content_offer_card.dart`
- `mapness/lib/pages/poi_card/poi_card_content.dart`, `poi_card_wrapper.dart`, `poi_card_widget_page.dart`, `founding_day_card_content.dart`
- `mapness/lib/pages/map_search/...`, `navi_search/...`, `routing/...` search result rows
- `mapness/lib/widgets/landing/dashboard_contents/base_dashboard_content.dart`, `makkah_based_dashboard_content.dart`
- `mapness/lib/features/app_feedback/send_feedback.dart`
- `mapness/lib/widgets/search/ui/search_item.dart`

To see the exact, authoritative diff at any time:

```bash
git show 08bae7b7d                 # full removal diff
git show 08bae7b7d --stat          # file list only
```
