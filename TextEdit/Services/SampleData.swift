import Foundation

enum SampleData {
    static var documents: [TextDocument] {
        [
            make("Intro to Ecology", body: "Intro to Ecology\n\n1. What is Ecology?\n\nEcology is the study of the relationships between living organisms and their environment. It examines how organisms interact with each other and with the non-living components of their surroundings.\n\n2. Core Principles\n\n• Everything is connected.\n• Energy flows through ecosystems.\n• Matter cycles within ecosystems.\n• Biodiversity strengthens resilience.\n\n3. Why It Matters\n\nUnderstanding ecology helps us make informed decisions about conservation, sustainability, and our impact on the planet.", kind: .rtf, favorite: true),
            make("Field Notes", body: "Field observations...", kind: .rtf),
            make("Poetry Study", body: "Poetry analysis", kind: .rtf, favorite: true),
            make("Essay Outline", body: "I. Introduction", kind: .rtf),
            make("Ideas.txt", body: "Ideas...", kind: .txt),
            make("Plant Study", body: "Plant notes", kind: .rtf),
            make("Weekly Reflection", body: "Week reflection", kind: .rtf),
            make("Research Draft", body: "Draft", kind: .rtf)
        ]
    }

    private static func make(_ title: String, body: String, kind: TextDocument.Kind, favorite: Bool = false) -> TextDocument {
        TextDocument(id: UUID(), title: title, fileName: title, kind: kind, isFavorite: favorite, updatedAt: .now, sizeBytes: max(12000, body.count * 2), attributedRTFData: nil, plainText: body)
    }
}
