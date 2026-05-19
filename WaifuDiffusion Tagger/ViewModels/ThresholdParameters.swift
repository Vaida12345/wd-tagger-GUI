//
//  ThresholdParameters.swift
//  WaifuDiffusion Tagger
//
//  Created by Vaida on 2026-05-19.
//

import Defaults


extension Defaults.Keys {
    var characterThreshold: Defaults.Key<Double> {
        .init("characterThreshold", default: 0.05)
    }
    
    var ratingThreshold: Defaults.Key<Double> {
        .init("ratingThreshold", default: 0.05)
    }
    
    var generalThreshold: Defaults.Key<Double> {
        .init("generalThreshold", default: 0.05)
    }
}
