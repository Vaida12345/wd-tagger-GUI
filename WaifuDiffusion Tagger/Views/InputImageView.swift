//
//  InputImageView.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI
import Essentials
import UniformTypeIdentifiers
import FinderItem
import NativeImage
import ViewCollection


struct InputImageView: View {
    
    @Environment(Coordinator.self) private var coordinator
    
    @State private var showFileImporter = false
    
    var body: some View {
        GroupBox {
            if let image = coordinator.image {
                ZStack(alignment: .bottom) {
                    Image(nativeImage: NativeImage(cgImage: image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Button {
                        showFileImporter = true
                    } label: {
                        Label("Replace image...", systemImage: "photo.badge.plus")
                            .foregroundStyle(Color(light: { .black }, dark: { .white }))
                    }
                    .buttonStyle(.prominent)
                    .tint(.clear)
                    .padding()
                }
            } else {
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, 75)
                        .imageScale(.large)
                        .fontWeight(.light)
                    
                    Button {
                        showFileImporter = true
                    } label: {
                        Label("Add image...", systemImage: "photo.badge.plus")
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 300, height: 300)
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.image]) { result in
            coordinator.reset()
            
            withErrorPresented("Failed to load image") {
                let url = try result.get()
                _ = url.startAccessingSecurityScopedResource()
                coordinator.image = try FinderItem(at: url).load(.cgImage)
            }
        }
        
        Text("You can also drag and drop images here")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.secondary)
            .font(.footnote)
            .padding(.leading, 5)
            .padding(.bottom)
    }
    
}

#if DEBUG
#Preview {
    InputImageView()
        .frame(width: 300)
        .environment(Coordinator.shared)
}
#endif
