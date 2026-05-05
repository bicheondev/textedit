# TextEdit (Native SwiftUI iPhone/iPad)

## Run
1. Open `TextEdit.xcodeproj` in Xcode on macOS.
2. Select an iPhone or iPad simulator.
3. Build and run.

> Validation status: This repository was updated in a Linux container, so `xcodebuild`/Xcode runtime verification could not be executed here. A macOS/Xcode verification pass is still required before release.

## Build correctness checklist (for macOS/Xcode)
- App target includes all Swift files in `TextEdit/App`, `Models`, `Services`, `Editor`, and `Views`.
- App target includes `TextEdit/Resources/Info.plist` and `TextEdit/Assets.xcassets`.
- Deployment target is iOS 17.0 and device family is iPhone+iPad.
- Automatic signing enabled (team must be set locally in Xcode).

## Current implementation status (not full TextEdit parity)
Implemented now:
- Native SwiftUI + UIKit `UITextView` editor (no WebView)
- iPad 3-column shell (`NavigationSplitView`) with refined fixed column widths
- iPhone navigation flow with compact translucent top bar and large title block
- First-launch seeded sample documents including Intro to Ecology
- Persistent local JSON-backed document state with autosave
- Formatting commands: bold, italic, underline, strikethrough, font size, alignment, bullet insertion
- Defensive formatting handling for missing editor reference, empty text, no selection, and active IME composition
- Glass-like formatting toolbar treatments for iPhone bottom bar and iPad floating bar

Partially implemented:
- `.rtf` serialization for in-app persisted document content

Not implemented yet (planned):
- Real external Files/iCloud Drive integration (Open in Place)
- Standalone `.txt` / `.rtf` file import/export flow
- Numbered list + indent/outdent commands
- Real generated thumbnails

## Manual validation checklist
- [ ] Launch on iPad simulator and confirm 3-column layout + sidebar/list/editor proportions
- [ ] Launch on iPhone simulator and confirm list -> editor push flow
- [ ] Confirm first-launch sample documents appear
- [ ] Open **Intro to Ecology** and verify it displays/editable
- [ ] Apply bold/italic/underline on selected text
- [ ] Change font size and alignment for current typing attributes
- [ ] Test Korean IME composition and ensure toolbar commands do not corrupt marked text
- [ ] Relaunch app and verify edits persist

## Screenshot parity pass (to complete on macOS)
Capture and attach to PR:
- iPhone portrait: document list
- iPhone portrait: editor with bottom toolbar visible
- iPad landscape: 3-column shell with floating formatting toolbar
- iPad landscape: Intro to Ecology open in editor

## Next PR
- Real Files/iCloud integration
- `.txt` / `.rtf` external import/export
- RTF round-trip validation with macOS TextEdit
- iPad/iPhone screenshot parity pass after simulator captures
