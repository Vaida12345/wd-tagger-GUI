//
//  TaggerApp.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import SwiftUI

@main
struct TaggerApp: App {
    
    @State var coordinator: Coordinator
    @Environment(\.openURL) private var openURL
    
    var body: some Scene {
        Window("Tagger", id: "main") {
            ContentView()
                .environment(coordinator)
        }
        .windowIdealSize(.fitToContent)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .help) {
                Button {
                    if let url = URL(string: "https://github.com/Vaida12345/wd-tagger-GUI") {
                        openURL(url)
                    }
                } label: {
                    Label("Github Repo", systemImage: "globe")
                }
            }
        }
    }
    
    init() {
        let coordinator = Coordinator.shared
        coordinator.loadModel()
        self._coordinator = .init(initialValue: coordinator)
    }
}
