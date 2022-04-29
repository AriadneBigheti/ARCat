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
    private var cats: [Cat] = [Cat]()
    private var catsPlaced: Int = 0
    private var cancellables = Set<AnyCancellable>()
    private var anchor = AnchorEntity(plane: .horizontal)
    @Binding private var tutorialIndex: Int
    @Binding private var exploreIsRunning: Bool
    @Binding private var selectedCat: Entity?
    
    init(frame: CGRect, tutorialIndex: Binding<Int>, exploreIsRunning: Binding<Bool>, selectedCat: Binding<Entity?>) {
        self._exploreIsRunning = exploreIsRunning
        self._tutorialIndex = tutorialIndex
        self._selectedCat = selectedCat
        super.init(frame: frame)
        self.cats.append(Cat(view: self, name:"George", modelFile: "Persian", scale:5, ballonName: "persianBallon"))
        self.cats.append(Cat(view: self, name:"Lily", modelFile: "Kitten", scale:5, ballonName: "kittenBallon"))
       // self.cats.append(Cat(view: self, name:"Wolverine", modelFile: "Bengal", scale:5, ballonName: "bengalBallon"))
        self.cats.append(Cat(view: self, name:"Alaska", modelFile: "Norwegianforest", scale:5, ballonName: "norwegianforestBallon"))
    
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
       }
       config.planeDetection = .horizontal
       self.session.run(config)
    }
    
    func placeModel(_ model: Entity){
        anchor.addChild(model)
        self.scene.addAnchor(anchor)
    }

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        if exploreIsRunning{ //if the user choose to explore
            explore(tapLocation: tapLocation)
        }else{
            if catsPlaced<=cats.count-1{ // if not all cats were placed, place the next cat
                placeNextCat(tapLocation: tapLocation)
            }
            else{ //if all cats were placed, and we are not exploring, place a ballon in the selected cat
                placeBallon(tapLocation: tapLocation)
            }
        }
    }
          
    private func placeNextCat(tapLocation: CGPoint){
        let catIndex = catsPlaced
        
        if let result = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any).first {
            let resultAnchor = AnchorEntity(world: result.worldTransform)
            resultAnchor.addChild((cats[catIndex].modelEntity)!)
            self.scene.addAnchor(resultAnchor)
            cats[catIndex].animate()
            catsPlaced+=1
        }
        if catsPlaced == cats.count{ // if all cats were placed, go to the next tutorial instruction
            tutorialIndex += 1
        }
    }
    
    private func explore(tapLocation: CGPoint){
        removeAllBallons()
        
        let entity = self.entity(at: tapLocation)
        if let model = exploreHierarchy(entity: entity){ //if the user touches a cat entity, we change the state of selected cat
            self.selectedCat = model
        }
        else // if the user doesn't tapped a cat, we change the anchor of the selected cat
            if let cat = selectedCat{
            if let result = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any).first {
                let resultAnchor = AnchorEntity(world: result.worldTransform)
                resultAnchor.addChild(cat)
                self.scene.addAnchor(resultAnchor)
            }
        }
    }
    
    private func placeBallon(tapLocation: CGPoint){
        removeAllBallons()
        
        let entity = self.entity(at: tapLocation)
        if let model = exploreHierarchy(entity: entity){
            if let component: BallonComponent = model.components[BallonComponent.self]{ //place a ballon on the cat that was touched
                print(model.name)
                component.place(in: model)
            }
        }
        
        if howManyBalllonsAppered() >= 1{ //if 2 ballons appeared, go the next tutorial instruction
            if tutorialIndex<2{
                tutorialIndex+=1
            }
        }
    }
    
    private func exploreHierarchy(entity: Entity?) -> Entity? {
        
        if entity == nil {
            return nil
        }
        if let entity = entity as? AnchorEntity {//the function runs into the most distant parent from the entity touched, wich has to be an Anchor Entity, the Anchor Entity should have only one child: the cat entity, which is the one we want
            if entity.children.count == 1{
                return entity.children[0]
            }else{
                return nil
            }
        } else {
            return exploreHierarchy(entity: entity?.parent)
        }
        
    }
    
    private func howManyBalllonsAppered() -> Int{ // check how many ballons the user touched, in order to continue the instructions
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
    
    private func removeAllBallons(){ //remove the ballons from all cats
        for cat in cats{
            if let component: BallonComponent = cat.modelEntity!.components[BallonComponent.self]{
                component.remove()
            }
        }
    }
    
}
