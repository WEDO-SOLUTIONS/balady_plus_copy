---
applyTo: "android/**,ios/**,urbi_map/**/*.kt,urbi_map/**/*.swift,urbi_map/**/*.m,urbi_map/**/*.mm,urbi_map/**/*.gradle,urbi_map/**/*.podspec"
---

Follow the repository-root `AGENTS.md` and `urbi_map/AGENTS.md` when working in plugin-native code.

Keep Flutter-facing APIs, platform-interface types, and native implementations aligned. Avoid one-sided native changes that silently break Dart callers.

Do not hand-edit generated Pigeon outputs:

- `urbi_map/dgis_map/android/src/main/kotlin/com/dgis/map/map_api/Messages.kt`
- `urbi_map/dgis_map/ios/Classes/Messages.swift`

Edit the schema in `urbi_map/dgis_map_platform_interface/pigeons/messages.dart`, then regenerate from the repo root with `just build_pigeon`.

Do not introduce SDK keys, signing data, or copied credentials into tracked files.

Be conservative around plugin initialization, vendor config flow, and Android Auto code paths because regressions there are hard to diagnose.
