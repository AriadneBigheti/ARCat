//
//  File.swift
//  
//
//  Created by Ariadne Bigheti on 20/04/22.
//
import SwiftUI
import RealityKit
import Combine

class InteractionSettings: ObservableObject {
    @Published var didTapPlayButton: Bool = false
    @Published var didTapExploreButton: Bool = false
    
}
