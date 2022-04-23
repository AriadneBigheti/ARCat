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
    var cats: [Cat] = [Cat]()
    var index: Int = 0
    private var cancellables = Set<AnyCancellable>()
    var anchor = AnchorEntity(plane: .horizontal)
    var isAnchorActivaded = false
    var isSceneReconstructionActivated = false
    @Binding var tutorialIndex: Int
    @Binding var exploreIsRunning: Bool
    @Binding var selectedCat: Entity?
    
    init(frame: CGRect, tutorialIndex: Binding<Int>, exploreIsRunning: Binding<Bool>, selectedCat: Binding<Entity?>) {
        self._exploreIsRunning = exploreIsRunning
        self._tutorialIndex = tutorialIndex
        self._selectedCat = selectedCat
        super.init(frame: frame)
        self.cats.append(Cat(view: self, name:"Bengal", scale:4, ballonName: "bengalBallon"))
        self.cats.append(Cat(view: self, name:"Kitten", scale:6, ballonName: "kittenBallon"))
        self.cats.append(Cat(view: self, name:"Persian", scale:5, ballonName: "persianBallon"))
        self.cats.append(Cat(view: self, name:"Norwegianforest", scale:4, ballonName: "norwegianforestBallon"))
    
        configure()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handleTap(_:))))
    }

    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    
    private func configure(){
       let config = ARWorldTrackingConfiguration()
        
       if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth){
            config.frameSemantics.insert(.personSegmentationWithDepth)
       }
       if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification){
            config.sceneReconstruction = .meshWithClassification
           self.isSceneReconstructionActivated = true
       }
       config.planeDetection = .horizontal
     //  self.debugOptions.insert(.showSceneUnderstanding)
       self.session.run(config)
    }
    
    func placeModel(_ model: Entity){
        anchor.addChild(model)
        self.scene.addAnchor(anchor)
    }
    
    func placeCat(index:Int){
        if let modelEntity = cats[index].modelEntity{
            placeModel(modelEntity)
            cats[index].animate()
        }
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        if exploreIsRunning{
            removeAllBallons()
            let entity = self.entity(at: tapLocation)
            if let model = exploreHierarchy(entity: entity){
                self.selectedCat = model
            }else
                if let cat = selectedCat{
                if let result = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any).first {
                    let resultAnchor = AnchorEntity(world: result.worldTransform)
                    resultAnchor.addChild(cat)
                    self.scene.addAnchor(resultAnchor)
                    if let component: BallonComponent = cat.components[BallonComponent.self]{
                        //animate
                        print("animation is running")
                    }
                }
            }
        }else{
            if index<=cats.count-1{
                if let result = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any).first {
                    let resultAnchor = AnchorEntity(world: result.worldTransform)
                    resultAnchor.addChild((cats[index].modelEntity)!)
                    self.scene.addAnchor(resultAnchor)
                    cats[index].animate()
                    index+=1
                }
                if index == cats.count{
                    tutorialIndex += 1
                }
            }
            else{
                removeAllBallons()
                let entity = self.entity(at: tapLocation)
                if let model = exploreHierarchy(entity: entity){
                    if howManyBalllonsAppered() >= 1{
                        if tutorialIndex<2{
                            tutorialIndex+=1
                        }
                    }
                    if let component: BallonComponent = model.components[BallonComponent.self]{
                        print(model.name)
                        print("tem componente")
                        component.place(in: model)
                        component.hasAppered = true
                    }
                }
            }
        }
    }
            
    
    func exploreHierarchy(entity: Entity?) -> Entity? {
        
        if entity == nil {
            return nil
        }
        if let entity = entity as? AnchorEntity {
            if entity.children.count == 1{
                return entity.children[0]
            }else{
                return nil
            }
        } else {
            return exploreHierarchy(entity: entity?.parent)
        }
        
    }
    
    func howManyBalllonsAppered() -> Int{
        var i = 0
        
        for cat in cats{
            if let model = cat.modelEntity{
                if let component: BallonComponent = model.components[BallonComponent.self]{
                    if component.hasAppered{
                        i+=1
                    }
                }
            }
        }
        
        return i
    }
    
    func removeAllBallons(){
        for cat in cats{
            if let component: BallonComponent = cat.modelEntity!.components[BallonComponent.self]{
                print("tem componente")
                component.remove()
            }
        }
    }
    
}
