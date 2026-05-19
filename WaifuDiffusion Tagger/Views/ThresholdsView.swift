//
//  ThresholdsView.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import Defaults


struct ThresholdsView: View {
    
    @AppStorage(\.generalThreshold) private var generalThreshold
    @AppStorage(\.characterThreshold) private var characterThreshold
    @AppStorage(\.ratingThreshold) private var ratingThreshold
    
    @Environment(Coordinator.self) private var coordinator
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tag thresholds")
                .foregroundStyle(.secondary)
                .fontWeight(.medium)
            
            ThresholdEditor(title: "General", value: $generalThreshold)
            Divider()
            ThresholdEditor(title: "Character", value: $characterThreshold)
        }
    }
    
}

#if DEBUG
#Preview {
    ThresholdsView()
}
#endif
