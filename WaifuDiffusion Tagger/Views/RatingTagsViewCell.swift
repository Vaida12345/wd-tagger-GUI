//
//  RatingTagsViewCell.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import WaifuDiffusionTagger


struct RatingTagsViewCell: View {
    
    let word: RatingTagsView.Model.Word
    let color: Color
    let totalWidth: Double
    
    @Binding var selectedRating: String?
    
    var widthWeight: CGFloat {
        if let selectedRating {
            selectedRating == self.word.tag.name ? 1 : 0
        } else {
            CGFloat(word.weight)
        }
    }
    
    var body: some View {
        if widthWeight > 0.1 {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                    .stroke(color.opacity(0.75), style: .init())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if widthWeight > 0.2 {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(word.tag.name, forType: .string)
                    } label: {
                        HStack(spacing: 6) {
                            if selectedRating == word.tag.name || word.tag.probability > 0.5 {
                                Text(word.tag.probability, format: .number.precision(.fractionLength(2)))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Text(word.tag.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .lineLimit(1)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 5)
                }
            }
            .frame(width: totalWidth * widthWeight, height: 25)
            .onHover {
                selectedRating = $0 ? word.tag.name : nil
            }
        }
    }
    
}

#if DEBUG
#Preview {
    @Previewable @State var selection: String? = nil
    RatingTagsViewCell(word: .init(weight: 0.36, tag: .preview), color: .blue, totalWidth: 300, selectedRating: $selection)
        .padding()
}
#endif
