//
//  TagsView.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import WaifuDiffusionTagger


struct DetailsView: View {
    
    @Environment(Coordinator.self) private var coordinator
    
    var body: some View {
        if let collected = coordinator.collectedResults {
            ScrollView {
                VStack(alignment: .leading, spacing: 3) {
                    if let tags = collected[.general] {
                        TagsView(title: "General Tags", tags: tags)
                        
                        Text("Click on a tag to copy")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .padding(.leading, 5)
                            .padding(.bottom, 12)
                    }
                    
                    if let tags = collected[.character] {
                        TagsView(title: "Character Tags", tags: tags)
                            .padding(.bottom, 12)
                    }
                    
                    RatingTagsView(tags: collected[.rating] ?? [])
                }
                .padding()
            }
        } else {
            GroupBox("Tags") {
                VStack {
                    if coordinator.stage != .awaitingInput {
                        ProgressView()
                        
                        Text(coordinator.stage.localizedStringResource)
                    }
                }
                .frame(width: 300)
                .frame(maxHeight: .infinity)
            }
            .padding()
        }
    }
    
}

#if DEBUG
#Preview {
    DetailsView()
        .environment(Coordinator.shared)
}
#endif
