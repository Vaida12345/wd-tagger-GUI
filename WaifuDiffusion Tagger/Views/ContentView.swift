//
//  ContentView.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import ViewCollection
import Defaults
import FinderItem
import Essentials
import NativeImage


struct ContentView: View {
    
    @Environment(Coordinator.self) private var coordinator
    @State private var isDropTargeted = false
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                InputImageView()
                ThresholdsView()
            }
            .frame(width: 300)
            .padding()
            
            Divider()
            
            DetailsView()
        }
        .dropDestination(for: FinderItem.self) { items, _ in
            coordinator.reset()
            
            let value = withErrorPresented("Failed to load image") {
                try? items.first?.startAccessingSecurityScopedResource()
                coordinator.image = try items.first?.load(.cgImage)
                return true
            }
            return value ?? false
        } isTargeted: {
            isDropTargeted = $0
        }
        .task(id: coordinator.image, priority: .utility) {
            guard coordinator.image != nil else { return }
            await withErrorPresented("Failed to predict tags") {
                try await coordinator.predict()
            }
        }
        .ignoresSafeArea()
        .frame(height: 500)
        .overlay {
            if isDropTargeted {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "photo.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .imageScale(.large)
                        .offset(x: 10)
                    
                    Text("Add dragged image")
                        .font(.title)
                        .fontWeight(.medium)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Coordinator.shared)
}
