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
    var box: Box?
    var cancellables = Set<AnyCancellable>()
    var sceneObserver: Cancellable?
    var anchor = AnchorEntity(plane: .horizontal)
    var isAnchorActivaded = false
    var occlusionBox: ModelEntity?
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        focusEntity = FocusEntity(on: self, focus: .classic)
        model = Cat(view: self)
        box = Box(view: self)
        checkAnchorState()
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkAnchorState(){
        self.scene.subscribe(to: SceneEvents.AnchoredStateChanged.self) { [self] (event) in
            if (((focusEntity?.anchor?.isActive)) != nil) {
                print("anchor is activaded")
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
            animateCat()
        }
    }
    
    func animateCat(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.model?.moveCat()
        }
    }
   
    func generateOcclusionBox(){
        let material = OcclusionMaterial()
        let boxSize: Float = 1
        let occlusionBoxMesh = MeshResource.generateBox(size: boxSize)
        self.occlusionBox = ModelEntity(mesh: occlusionBoxMesh, materials: [material])
       
        self.occlusionBox?.position.z = -1
        
        anchor.addChild(self.occlusionBox!)
        
    }
    
}
