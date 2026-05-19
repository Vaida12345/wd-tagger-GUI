//
//  Coordinator.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import Observation
import WaifuDiffusionTagger
import CoreGraphics
import Essentials
import Foundation
import Defaults


@MainActor
@Observable
final class Coordinator {
    
    var tagger: Tagger?
    var taggerLoadTask: Task<Void, any Error>?
    
    var image: CGImage?
    
    @ObservationIgnored
    var results: Tagger.Output?
    var collectedResults: [Tagger.Tag.Category : [Tagger.Output.Element]]?
    
    var stage: Stage = .awaitingInput
    
    func reset() {
        self.stage = .awaitingInput
        self.image = nil
        self.results = nil
        self.collectedResults = nil
    }
    
    func loadModel() {
        self.taggerLoadTask = Task {
            let tagger = try await Tagger()
            self.tagger = tagger
        }
    }
    
    func predict() async throws {
        guard let image else { throw PredictionError.noImage }
        
        self.stage = .loadingModel
        try await taggerLoadTask?.value
        guard let tagger else { throw PredictionError.noTagger }
        self.stage = .predicting
        
        self.results = try await tagger.predict(image)
        self.updateCollectedResults()
        self.stage = .showingResults
    }
    
    func updateCollectedResults(
        character: Float? = nil,
        rating: Float? = nil,
        general: Float? = nil
    ) {
        guard let results else { return }
        self.collectedResults = results.collected(
            thresholds: [
                .character : character ?? Float(Defaults.standard.characterThreshold),
                .general : general ?? Float(Defaults.standard.generalThreshold),
                .rating : rating ?? Float(Defaults.standard.ratingThreshold)
            ]
        )
    }
    
    private init() { }
    static let shared = Coordinator()
    
    enum PredictionError: LocalizableError {
        case noImage
        case noTagger
        
        var messageResource: LocalizedStringResource {
            switch self {
            case .noImage: "No image provided"
            case .noTagger: "Tagger not loaded"
            }
        }
    }
    
    enum Stage: CustomLocalizedStringResourceConvertible {
        case awaitingInput
        case loadingModel
        case predicting
        case showingResults
        
        var localizedStringResource: LocalizedStringResource {
            switch self {
            case .awaitingInput:
                "Waiting Input"
            case .loadingModel:
                "Preparing Model"
            case .predicting:
                "Predicting"
            case .showingResults:
                "Showing Results"
            }
        }
    }
    
}


extension Tagger.Tag: @retroactive Identifiable {
    public var id: Int { self.tag_id }
}
extension Tagger.Output.Element: @retroactive Identifiable {
    public var id: Int { self.tag.id }
}
