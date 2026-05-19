//
//  ThresholdEditor.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import Essentials


struct ThresholdEditor: View {
    
    let title: LocalizedStringResource
    @Binding var value: Double
    
    @Environment(Coordinator.self) private var coordinator
    
    var body: some View {
        Section {
            LabeledContent {
                TextField("", value: $value.clamp(to: 0...1), format: .number.precision(.fractionLength(2)))
                    .help("Only tags with a confidence above this value will be shown.")
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        coordinator.updateCollectedResults()
                    }
            } label: {
                Text(title)
            }
            
            Slider(value: $value) {
                guard !$0 else { return }
                coordinator.updateCollectedResults()
            }
        }
    }
    
}

#if DEBUG
#Preview {
    @Previewable @State var value = 0.0
    
    VStack(alignment: .leading) {
        ThresholdEditor(title: "Character", value: $value)
    }
    .padding()
}
#endif


extension Binding where Value == Double {
    public func clamp(to range: ClosedRange<Value>) -> Binding<Value> {
        return .init(
            get: { self.wrappedValue },
            set: { self.wrappedValue = Essentials.clamp($0, min: 0, max: 1) }
        )
    }
}
