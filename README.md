# TextEdit (Native SwiftUI iPhone/iPad)

## Run
1. Open `TextEdit.xcodeproj` in Xcode.
2. Select an iPhone or iPad simulator.
3. Build and run.

## Current implementation status
Implemented now:
- Native SwiftUI + UIKit `UITextView` rich text editor (no WebView)
- iPad 3-column shell (`NavigationSplitView`) and iPhone navigation flow
- First-launch seeded sample documents including Intro to Ecology
- Persistent local JSON document metadata with autosave
- Editing commands wired to selection/typing attributes: bold, italic, underline, strikethrough, font size, alignment, bullet insertion

Partially implemented:
- `.rtf` serialization of current editor content for persisted document state

Not implemented yet (planned):
- Real external Files/iCloud Drive picker/browser integration (Open in Place)
- Full import/export pipeline for standalone `.txt` / `.rtf` files
- Numbered list, indent/outdent commands
- Real rendered document thumbnails

## Manual validation checklist
- [ ] Launch on iPad simulator and confirm 3-column layout
- [ ] Launch on iPhone simulator and confirm list -> editor push flow
- [ ] Select text and apply bold/italic/underline/strikethrough
- [ ] Change font size and alignment
- [ ] Insert bullets
- [ ] Relaunch app and verify edited content persisted

## Reference fidelity notes
- Uses native materials, rounded glass-like formatting bar, restrained grayscale chrome, green section heading style.
- UI is intentionally close to the provided references while remaining fully native.
