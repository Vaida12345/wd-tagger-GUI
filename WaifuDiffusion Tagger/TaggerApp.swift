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
    
    var body: some Scene {
        Window("Tagger", id: "main") {
            ContentView()
                .environment(coordinator)
        }
        .windowIdealSize(.fitToContent)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
    
    init() {
        let coordinator = Coordinator.shared
        coordinator.loadModel()
        self._coordinator = .init(initialValue: coordinator)
    }
}
