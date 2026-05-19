//
//  RatingTagsView.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import WaifuDiffusionTagger


struct RatingTagsView: View {
    
    let model: Model
    
    var spacer: Double {
        4
    }
    
    var totalWidth: Double {
        if selection == nil {
            300 - spacer * max(Double(model.count(where: { $0.tag.probability > 0.1 }) - 1), 0)
        } else {
            300
        }
    }
    
    @State private var selection: String? = nil
    
    var body: some View {
        GroupBox("Rating") {
            HStack(spacing: spacer) {
                RatingTagsViewCell(word: model.general, color: .green, totalWidth: totalWidth, selectedRating: $selection)
                RatingTagsViewCell(word: model.sensitive, color: .yellow, totalWidth: totalWidth, selectedRating: $selection)
                RatingTagsViewCell(word: model.questionable, color: .orange, totalWidth: totalWidth, selectedRating: $selection)
                RatingTagsViewCell(word: model.explicit, color: .red, totalWidth: totalWidth, selectedRating: $selection)
            }
            .frame(width: 300)
            .animation(.spring.speed(2), value: selection)
        }
    }
    
    init(tags: [Tagger.Output.Element]) {
        let total = max(tags.reduce(0) { $0 + ($1.probability > 0.1 ? $1.probability : 0) }, 0.1)
        
        self.model = Model(
            general: Model.Word(name: "general", total: total, tags: tags),
            sensitive: Model.Word(name: "sensitive", total: total, tags: tags),
            questionable: Model.Word(name: "questionable", total: total, tags: tags),
            explicit: Model.Word(name: "explicit", total: total, tags: tags)
        )
    }
    
    struct Model: Sequence {
        let general: Word
        let sensitive: Word
        let questionable: Word
        let explicit: Word
        
        func makeIterator() -> IndexingIterator<Array<Word>> {
            [general, sensitive, questionable, explicit].makeIterator()
        }
        
        struct Word {
            let weight: Float
            let tag: Tagger.Output.Element
            
            init(weight: Float, tag: Tagger.Output.Element) {
                self.weight = weight
                self.tag = tag
            }
            
            init(name: String, total: Float, tags: [Tagger.Output.Element]) {
                self.tag = tags.first(where: { $0.name == name }) ?? .init(id: .random(in: .min ... 0), name: "<unknown>", category: .rating, count: 10, probability: 0)
                self.weight = self.tag.probability / total
            }
        }
    }
    
}

#if DEBUG
#Preview {
    let ratingTags: [Tagger.Output.Element] = [
        .init(id: 0, name: "general", category: .rating, count: 10, probability: 0.9),
        .init(id: 1, name: "sensitive", category: .rating, count: 10, probability: 0.9),
        .init(id: 2, name: "questionable", category: .rating, count: 10, probability: 0.1),
        .init(id: 3, name: "explicit", category: .rating, count: 10, probability: 0.0),
    ]
    RatingTagsView(tags: ratingTags)
        .padding()
}
#endif
