# Landing Widgets Notes

This subtree contains dashboard content, quick actions, and `Drive back home`.

## Session Context

The QA scenario under investigation:

1. Open app as unauthenticated user.
2. Tap `Drive back home`.
3. Authenticate.
4. Enter an address in favourites search.
5. Build navigation to that point.
6. UI disappears except the map.

The working diagnosis was a timing race between auth, favourites persistence, landing sheet hiding, and route stack transitions. Debug builds may not reproduce because debug timing hides races; validate in profile/release for this class of issues.

## Rules For This Subtree

- Do not push navigation routes while auth callbacks or favourites home/work writes are still in flight.
- For `DriveBackHomeCard`, keep the flow sequential: hide/settle sheet -> auth -> read/select home -> persist home -> setup map -> push routing.
- Keep `mounted`/`context.mounted` checks after every async gap before using context/router/ref-dependent UI state.
- If hiding `MultiStateSheet`, allow at least a short settle delay before route pushes. This is intentionally defensive around sheetify route/sheet interaction.
- If no home, cancellation, or missing location stops the flow, consider whether the landing sheet should be restored instead of leaving it hidden.
- Avoid introducing fire-and-forget route navigation in dashboard actions such as `Drive back home` or `Contribute`.

## Important Files

- `drive_back_home_card.dart`: auth-gated drive-home flow and sheet hiding.
- `dashboard_contents/base_dashboard_content.dart`: `Contribute` route push from dashboard.
- `dashboard/dashboard.dart`: sheet state listener and map controls interaction.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/widgets/landing/drive_back_home_card.dart mapness/lib/widgets/landing/dashboard_contents/base_dashboard_content.dart
rtk fvm flutter analyze --no-pub mapness/lib/widgets/landing/drive_back_home_card.dart mapness/lib/widgets/landing/dashboard_contents/base_dashboard_content.dart
```
