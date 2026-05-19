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
                VStack(alignment: .leading, spacing: 15) {
                    if let tags = collected[.general] {
                        TagsView(title: "General Tags", tags: tags)
                    }
                    
                    if let tags = collected[.character] {
                        TagsView(title: "Character Tags", tags: tags)
                    }
                    
                    if let tags = collected[.rating] {
                        TagsView(title: "Rating Tags", tags: tags)
                    }
                    
                    Text("Click on a tag to copy")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .padding(.leading, 5)
                        .padding(.bottom)
                        .offset(y: -12)
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
