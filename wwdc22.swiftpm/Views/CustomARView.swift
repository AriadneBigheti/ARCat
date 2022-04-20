//
//  File.swift
//  wwdc22
//
//  Created by Ariadne Bigheti on 12/04/22.
//

import RealityKit
import ARKit
import Combine
import SwiftUI

class CustomARView: ARView{
    var focusEntity: FocusEntity?
    var model: Cat?
    private var cancellables = Set<AnyCancellable>()
    var sceneObserver: Cancellable?
    var playButtonObserver: AnyCancellable?
    var exploreButtonObserver: AnyCancellable?
    var anchor = AnchorEntity(plane: .horizontal)
    var isAnchorActivaded = false

    
    required init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        focusEntity = FocusEntity(on: self, focus: .classic)
        model = Cat(view: self)
        checkAnchorState()

    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkAnchorState(){
        self.scene.subscribe(to: SceneEvents.AnchoredStateChanged.self) { [self] (event) in
            if ((focusEntity?.isAnchored) != nil){
                self.isAnchorActivaded = true
            }else{
                self.isAnchorActivaded = false
            }
        }.store(in: &cancellables)
    }
    
    private func configure(){
       let config = ARWorldTrackingConfiguration()
        
       if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth){
            config.frameSemantics.insert(.personSegmentationWithDepth)
       }
        
       //config.sceneReconstruction = .meshWithClassification
       config.planeDetection = [.horizontal]
       self.debugOptions.insert(.showSceneUnderstanding)
       self.session.run(config)
        
    }
    
    func placeModel(_ model: Entity){
        anchor.addChild(model)
        self.scene.addAnchor(anchor)
    }
    
    func placeCat(){
        if let modelEntity = model?.modelEntity{
            placeModel(modelEntity)
            self.model?.animate()
        }
    }
    
}
