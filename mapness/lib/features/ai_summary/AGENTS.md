# AI Summary Notes

This subtree owns the POI AI Summary card, repository/cache/state, preview, and UI tokens.

## Session Context

The current session fixed header overflow/spacing in `ui/ai_summary_card.dart`. Screenshots showed long English/Arabic labels escaping the card and then an excessive gap between title and badge after an initial `Expanded`-based fix.

## Rules For This Subtree

- Header title and badge must sit next to each other with only `AiSummaryTokens.headerSpacing` between them.
- Do not put the title in `Expanded` if that creates a full-width gap before the badge. Use constrained `Flexible` layout so the title takes only needed/available width.
- Use `AutoSizeText` for long localized title/badge text, with `maxLines: 1` and ellipsis. Keep the badge compact; do not stretch the badge pill across the row.
- Badge text should also be protected against overflow because localized copy can be longer than the current English/Arabic fixture.
- Avoid debug/test strings in production UI. Earlier screenshots exposed a temporary long test title string; do not leave this in the file.

## Important Files

- `ui/ai_summary_card.dart`: card layout and header.
- `ui/ai_summary_tokens.dart`: layout and text tokens; prefer token changes for spacing/typography adjustments.
- `ui/ai_summary_preview_page.dart`: useful for manual visual inspection with fixtures.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/features/ai_summary/ui/ai_summary_card.dart
rtk fvm flutter analyze --no-pub mapness/lib/features/ai_summary/ui/ai_summary_card.dart
```
