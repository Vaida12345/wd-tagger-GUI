//
//  TagsView.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import WaifuDiffusionTagger


struct TagsView: View {
    
    let title: LocalizedStringResource
    let tags: [Tagger.Output.Element]
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GroupBox(title) {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(tags) { tag in
                        Button {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(tag.name, forType: .string)
                        } label: {
                            HStack {
                                Text(tag.probability, format: .number.precision(.fractionLength(2)))
                                    .foregroundStyle(.secondary)
                                
                                Text(tag.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .padding(.all, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(nsColor: .secondarySystemFill))
                                .frame(width: 300 * CGFloat(tag.probability))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(width: 300)
            }
            
            Button {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(tags.map(\.name).joined(separator: ", "), forType: .string)
            } label: {
                Label("Copy", systemImage: "document.on.document")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .controlSize(.mini)
            .padding(.top, 2)
            .padding(.trailing, 8)
        }
    }
    
}

#if DEBUG
#Preview {
    TagsView(title: "Tags", tags: [.preview, .preview])
}
#endif
