# TextEdit (iPhone + iPad)

A native SwiftUI document-oriented editor inspired by Apple TextEdit for iOS/iPadOS.

## Run
1. Open `TextEdit.xcodeproj` in Xcode 16+.
2. Select `TextEdit` scheme.
3. Run on an iPhone or iPad simulator (iOS 18+ target in project settings if needed).

## Supported platforms
- iPhone (compact navigation stack)
- iPad (3-column `NavigationSplitView`)
- Light/Dark Mode
- Stage Manager / Split View-friendly adaptive layout

## Implemented features
- Document browser sections (All Documents, Recents, Shared, Favorites, Locations, Tags)
- Sample data loaded on first launch
- Row metadata (preview icon, title, date/time, size, favorite)
- Real rich text editor (`UITextView` bridge, no WebView)
- Formatting controls: font family, size, bold, italic, underline, strikethrough, alignment, bullet/number list insertion, indent/outdent
- Keyboard shortcuts: Cmd-B/I/U/S + undo/redo wiring through system responder
- Autosave on edit with safe atomic writes

## Supported file types
- `.txt`
- `.rtf`

## Known gaps
- `.rtfd` attachments are not yet implemented (architecture leaves room via serializer/protocol boundary).
- Thumbnail previews are metadata-driven placeholders (not rendered page snapshots).
- iCloud Drive is represented as a location section label, not full UIDocumentBrowser integration.

## Reference mapping
- iPad 3-column structure mapped via `NavigationSplitView`
- iPhone list->editor push flow mapped with `NavigationStack`
- Floating iPad formatting toolbar and bottom iPhone formatting toolbar via adaptive toolbar container and materials
- Green section headings + restrained grayscale chrome align with provided references
- Custom app icon asset included using lined paper + red margin style
