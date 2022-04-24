//
//  PlacementSettings.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 18/04/22.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    @Published var isAnchorActivaded: Bool = false
    @Published var didTapButton: Bool = false
    @Published var didTapPlayButton: Bool = false
    @Published var didTapExploreButton: Bool = false
    
    var shouldAddModel: Bool = false
    var modelIsPlaced = false
    
    private var cancellableSet: Set<AnyCancellable> = []
        
    init() {
        shouldEnableButtonPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.shouldAddModel, on: self)
            .store(in: &cancellableSet)
        
    }
    
    var shouldEnableButtonPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($didTapButton, $isAnchorActivaded)
        
            .map { didTapButton, isAnchorActivaded in
                return didTapButton && isAnchorActivaded
            }
            .eraseToAnyPublisher()
    }
}

