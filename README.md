# TextEdit (Native SwiftUI iPhone/iPad)

## Run
1. Open `TextEdit.xcodeproj` in Xcode on macOS.
2. Select an iPhone or iPad simulator.
3. Build and run.

> Note: this repository was edited in a Linux container without Xcode. Final compile/run verification is still required on macOS with Xcode.

## Current implementation status (not full TextEdit parity)
Implemented now:
- Native SwiftUI + UIKit `UITextView` editor (no WebView)
- iPad 3-column shell (`NavigationSplitView`) and iPhone navigation flow
- First-launch seeded sample documents including Intro to Ecology
- Persistent local JSON-backed document state with autosave
- Formatting commands: bold, italic, underline, strikethrough, font size, alignment, bullet insertion
- Defensive formatting handling for missing editor reference, empty text, no selection, and active IME composition

Partially implemented:
- `.rtf` serialization for in-app persisted document content

Not implemented yet (planned):
- Real external Files/iCloud Drive integration (Open in Place)
- Standalone `.txt` / `.rtf` file import/export flow
- Numbered list + indent/outdent commands
- Real generated thumbnails

## Manual validation checklist
- [ ] Launch on iPad simulator and confirm 3-column layout
- [ ] Launch on iPhone simulator and confirm list -> editor push flow
- [ ] Apply rich formatting and verify active-state button highlighting
- [ ] Test Korean IME composition and ensure toolbar commands do not corrupt marked text
- [ ] Relaunch app and verify seeded sample data appears first run and edits persist

## Next PR
- Real Files/iCloud integration
- `.txt` / `.rtf` external import/export
- RTF round-trip validation with macOS TextEdit
- iPad/iPhone screenshot parity pass
